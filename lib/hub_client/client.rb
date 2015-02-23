class HubClient::Client
  attr_reader :config

  def initialize options
    @config = HubClient::Config.new options
  end

  def notify path, data
    raise "Hub client is disabled" if not enabled?
    RestClient.post "#{@config.url}/api/notify/connectors/#{connector_guid}/#{path}", data,
      content_type: 'application/json',
      "X-InSTEDD-Hub-Token" => token
  end

  def enabled?
    config.enabled
  end

  def url
    config.url
  end

  def connector_guid
    config.connector_guid || raise("A connector guid must be specified in hub.yml")
  end

  def token
    config.token || raise("An authentication token must be specified in hub.yml")
  end
end
