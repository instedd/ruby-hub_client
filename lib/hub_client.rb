require "hub_client/version"
require "hub_client/config"
require "hub_client/client"
require "hub_client/api"

module HubClient
  def self.current options={}
    @current ||= Client.new options
  end
end
