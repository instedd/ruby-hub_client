require 'hub_client'
require 'rails'

module HubClient
  class Railtie < Rails::Railtie
    generators do
      require 'generators/hub_client/config_generator'
    end
  end
end
