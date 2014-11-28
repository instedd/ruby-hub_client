class HubClient::Client
  attr_reader :config

  def initialize options
    @config = HubClient::Config.new options
  end

  def notify connector, event, data
    RestClient.post "#{@config.url}/#{connector}/#{event}?token=#{@config.token}", data
  end

  def url
    config.url
  end
end
