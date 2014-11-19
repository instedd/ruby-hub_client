require "hub_client/version"
require "hub_client/config"
require "hub_client/client"

module HubClient
  def self.current options={}
    @current ||= Client.new options
  end
end
