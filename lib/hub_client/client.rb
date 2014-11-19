class HubClient::Client
  def initialize
    @config = HubClient::Config.new
  end

  def notify connector, event, data
    RestClient.post "#{@config.url}/#{connector}/#{event}?token=#{@config.token}", data
  end
end
