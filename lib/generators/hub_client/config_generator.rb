module HubClient
  class ConfigGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def config
      copy_file "hub.yml", "config/hub.yml"
    end
  end
end
