class HubClient::Config
  attr_reader :url, :token

  def initialize options
    config = YAML.load_file("#{Rails.root}/config/hub.yml") rescue {}
    config.merge! options

    @url = config["url"] || "https://hub.instedd.org/callback"
    @token = config["token"] || raise("An authentication token must be specified in hub.yml")
  end
end
