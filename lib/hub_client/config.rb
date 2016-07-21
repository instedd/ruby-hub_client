class HubClient::Config
  attr_reader :url, :token, :connector_guid, :enabled

  def initialize options
    # Prefer the `config` gem if available and a "hub" section exists
    if defined?(::Settings) && (hub = ::Settings.hub)
      config = hub.to_h
    else
      config = YAML.load_file("#{Rails.root}/config/hub.yml") rescue {}
    end

    config.merge! options

    @enabled = config.fetch('enabled', true)
    @url = config["url"] || "https://hub.instedd.org"
    @token = config["token"]
    @connector_guid = config["connector_guid"]
  end
end
