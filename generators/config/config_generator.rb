module MoIP
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      desc "Creates a Mongoid configuration file at config/mongoid.yml"

      argument :database_name, :type => :string, :optional => true

      def self.source_root
        @_moip_source_root ||= File.expand_path("/templates", __FILE__)
      end

      def app_name
        Rails::Application.subclasses.first.parent.to_s.underscore
      end

      def create_config_file
        template 'config.yml', File.join('config', "config.yml")
      end

    end
  end
end