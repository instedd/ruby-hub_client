class HubClient::Client
  def initialize options
    @config = HubClient::Config.new options
  end

  def notify connector, event, data
    RestClient.post "#{@config.url}/#{connector}/#{event}?token=#{@config.token}", data
  end
end
