module HubClient
  class Action
    attr_reader :api
    attr_reader :path

    def initialize(api, path)
      @api = api
      @path = path
    end

    def invoke(params)
      api.post("/api/invoke/#{path}", params.to_json)
    end
  end
end
