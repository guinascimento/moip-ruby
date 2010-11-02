require 'rails/generators'
require 'rails/generators/named_base'
 
module MoIP
  module Generators
    class MoIPGenerator < ::Rails::Generators::NamedBase
      desc "Creates a Mongoid configuration file at config/mongoid.yml"

      argument :database_name, :type => :string, :optional => true

      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def create_config_file
        template 'config.yml', File.join('config', "config.yml")
      end
    end
  end
end
