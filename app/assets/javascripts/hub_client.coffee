class HubApi
  # url: hub host url (example: 'http://hub.instedd.org')
  # proxy_pi: url to use for calling hub api on behalf current user: (example: '/hub' if that redirects to 'http://hub.instedd.org/api')
  constructor: (@url, @proxyApi = "#{url}/api") ->
    @pickers = {}

    if window.addEventListener
      window.addEventListener "message", (e) =>
        @_message(e)
      , false
    else
      window.attachEvent "onmessage", (e) =>
        @_message(e)


  openPicker: (type) ->
    valid_types = ['entity_set', 'action', 'event']
    console.error("called HubApi\#openPicker(type) with type=#{type}. valid values: #{valid_types.join(', ')}.") if $.inArray(type, valid_types) == -1

    pr = new PickerResult(@)
    pr.show(type)
    @pickers[pr.id] = pr
    pr

  reflect: (path) ->
    new ReflectPromise(@, path)

  reflectResult: (json) ->
    ReflectResult.fromJson(json)

  _message: (event) ->
    return if $.isEmptyObject(@pickers)
    data = JSON.parse(event.data)
    target = @pickers[data.target]
    target[data.message](data) if target

  _removePicker: (pr) ->
    delete @pickers[pr.id]

class ReflectPromise
  constructor: (@api, @path) ->
    @result = null
    $.getJSON "#{@api.proxyApi}/reflect/#{path}", (data) =>
      @result = new ReflectResult(data)
      @_performPromise()

  # callback: function(data) { ... }
  then: (callback) ->
    @callback = callback
    @_performPromise()

  _performPromise: ->
    @callback(@result) if @result and @result


class MemberField
  constructor: (@_parent, @_name, @_type, @_def) ->
  name: ->
    @_name
  label: ->
    @_def.label || @name()
  _jsonDef: ->
    @_def
  type: ->
    @_type
  isStruct: ->
    @_type == 'struct'
  path: ->
    (if @_parent then @_parent.path() else []).concat(@_name)

class ValueMemberField extends MemberField
  constructor: (parent, name, type, def) ->
    super(parent, name, type, def)
  visit: (callback) ->
    callback(@)

class StructMemberField extends MemberField
  constructor: (parent, name, def) ->
    super(parent, name, 'struct', def)
    @_fields = [] # Array of MemberField
  fields: ->
    @_fields
  isOpen: ->
    @_def.type.open
  visit: (callback) ->
    res = {}
    for field in @fields()
      res[field.name()] = field.visit(callback)
    res

  addOpenField: (name, type) ->
    console.error 'operation not support for non-open structs' unless @isOpen()
    new_field = if type == 'struct'
      new StructMemberField(@, name, {type: {kind: 'struct', open: true}})
    else
      new ValueMemberField(@, name, type, {type: type})

    @fields().push(new_field)

    new_field

  _jsonDef: ->
    res = super
    if @isOpen()
      # update members if the struct is open
      res.type.members = {}
      for f in @fields()
        res.type.members[f.name()] = f._jsonDef()
    res

class ReflectResult
  constructor: (@_data) ->
    @_args = []
    @_appendFields(null, @_args, @_data.args)
  label: ->
    @_data.label
  args: ->
    @_args
  visitArgs: (callback) ->
    res = {}
    for field in @args()
      res[field.name()] = field.visit(callback)
    res

  toJson: ->
    # update args in case they were changed
    for arg in @args()
      @_data.args[arg.name()] = arg._jsonDef()
    @_data

  @fromJson: (json) ->
    new ReflectResult(json)

  _buildMemberField: (parent, name, def) ->
    type = def.type?.kind || def.type
    if type == 'struct'
      res = new StructMemberField(parent, name, def)
      @_appendFields(res, res.fields(), def.type.members, def)
      res
    else
      new ValueMemberField(parent, name, type, def)
  _appendFields: (parent, target, members) ->
    for name, def of members
      target.push @_buildMemberField(parent, name, def)

class PickerResult
  constructor: (@api) ->
    @id = new Date().getTime()

  show: (type) ->
    @container = $('<div>')
      .css('position', 'fixed')
      .css('left', 0).css('right', 0).css('top', 0).css('bottom', 0).css('z-index', 1040)
    grayBackground =$('<div>')
      .css('background-color', 'black')
      .css('opacity', 0.8)
      .css('width', '100%')
      .css('height', '100%')
      .click( =>
        @close()
      )
    @container.append(grayBackground)
    $('body').append(@container)

    iframe = $("<iframe>").width(@container.width() * 0.8).height(@container.height() * 0.8)
      .attr('src', "#{@api.url}/api/picker?#{$.param(type: type)}")
      .css('position', 'absolute')
      .css('left', @container.width() * .1)
      .css('top', @container.height() * .1)
      .css('background-color', 'white')
      .css('border', '0')
    @container.append(iframe)

    @pickerWin = iframe[0].contentWindow

    @waitingTimer = window.setInterval( =>
      @pickerWin.postMessage(JSON.stringify({source: @id, message:"waiting"}), @api.url)
    ,500)

  id: ->
    @id

  loaded: (event) ->
    window.clearInterval(@waitingTimer)

  selected: (event) ->
    @close()
    @then(event.path, event.selection)

  close: ->
    @container.remove()
    @api._removePicker(@)

  then: (callback) ->
    @then = callback


window.HubApi = HubApi
