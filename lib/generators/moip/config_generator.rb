require 'rails/generators'
require 'rails/generators/named_base'

module Moip
  module Generators
    class ConfigGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def create_config_file
        template 'config.yml', File.join('config', "config.yml")
      end
    end
  end
end
