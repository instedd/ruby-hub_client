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
      PagedEnumeration.new(self, params)
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

    class PagedEnumeration
      include Enumerable

      def initialize(entity_set, params)
        @entity_set = entity_set
        @params = params
      end

      def api
        @entity_set.api
      end

      def each
        next_page_url = "#{@entity_set.data_path}?#{@params.to_query}"

        until next_page_url.blank?
          result = api.json(next_page_url)

          next_page_url = result['next_page']

          result['items'].each do |entity|
            yield entity
          end
        end
      end
    end
  end
end
