class HubClient::Config
  attr_reader :url, :token

  def initialize
    config = YAML.load_file("#{Rails.root}/config/hub.yml") rescue {}
    @url = config[:url] || "http://hub.instedd.org/callback"
    @token = config[:token] || "some_token"
  end
end
