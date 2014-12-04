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
      api.json(data_path, params)
    end

    def insert(properties)
      api.post(data_path, {properties: properties})
    end

    def update_many(filter, properties, create_or_update = false)
      params = {properties: properties, create_or_update: create_or_update}
      params[:filter] = filter unless filter.empty?
      api.put(data_path, params)
    end

    def delete(filter)
      params = {}
      params[:filter] = filter unless filter.empty?
      api.delete(data_path, params)
    end

    def data_path
      "/api/data/#{path}"
    end
  end
end
