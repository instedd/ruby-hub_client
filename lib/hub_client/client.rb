class HubClient::Client
  attr_reader :config

  def initialize options
    @config = HubClient::Config.new options
  end

  def notify connector, event, data
    RestClient.post "#{@config.url}/#{connector}/#{event}", data,
      content_type: 'application/json',
      "X-InSTEDD-Hub-Token" => @config.token
  end

  def url
    config.url
  end
end
