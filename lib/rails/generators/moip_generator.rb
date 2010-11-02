require "rails/generators/named_base"
require "rails/generators/active_model"

module MoIP #:nodoc:
  module Generators #:nodoc:
    class Base < ::Rails::Generators::NamedBase #:nodoc:

      def self.source_root
        @_moip_source_root ||=
        File.expand_path("../#{base_name}/#{generator_name}/templates", __FILE__)
      end
    end
  end
end