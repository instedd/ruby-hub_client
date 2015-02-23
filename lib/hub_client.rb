require "hub_client/version"
require "hub_client/config"
require "hub_client/client"
require "hub_client/api"
require 'hub_client/engine'

module HubClient
  require "hub_client/railtie" if defined?(Rails)

  def self.current options={}
    @current ||= Client.new options
  end
end
