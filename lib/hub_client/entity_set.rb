module HubClient
  class EntitySet
    attr_reader :api
    attr_reader :path

    def initialize(api, path)
      @api = api
      @path = path
    end

    # TODO return lazy enumeration of paged items
    # TODO support filtering
    def paged_where(attributes = {})
      params = {}
      params[:filter] = attributes unless attributes.empty?
      api.json("/api/data/#{path}", params)
    end
  end
end
