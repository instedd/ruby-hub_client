class HubClient::Config
  attr_reader :url, :token, :connector_guid

  def initialize options
    config = YAML.load_file("#{Rails.root}/config/hub.yml") rescue {}
    config.merge! options

    @url = config["url"] || "https://hub.instedd.org"
    @token = config["token"] || raise("An authentication token must be specified in hub.yml")
    @connector_guid = config["connector_guid"] || raise("A connector guid must be specified in hub.yml")
  end
end
