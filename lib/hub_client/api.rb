require "guisso/api"

class HubClient::Api < Guisso::Api
  # TODO refactor so default_host is a url with protocol
  def self.default_host
    uri = URI(HubClient.current.url)
    if uri.port == 80
      uri.host
    else
      "#{uri.host}:#{uri.port}"
    end
  end

  def self.default_use_ssl
    URI(HubClient.current.url).scheme == 'https'
  end
end