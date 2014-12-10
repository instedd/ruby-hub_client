class HubApi
  constructor: (@url) ->
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

  url: ->
    @url

  _message: (event) ->
    return if $.isEmptyObject(@pickers)
    data = JSON.parse(event.data)
    target = @pickers[data.target]
    target[data.message](data) if target

  _removePicker: (pr) ->
    delete @pickers[pr.id]

class PickerResult
  constructor: (@api) ->
    @id = Date.now()

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
    @then(event.path)

  close: ->
    @container.remove()
    @api._removePicker(@)

  then: (callback) ->
    @then = callback


window.HubApi = HubApi
