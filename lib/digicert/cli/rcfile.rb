require "yaml"
require "singleton"

module Digicert
  module CLI
    class RCFile
      include Singleton
      attr_reader :path, :data
      FILE_NAME = ".digicertrc".freeze

      def initialize
        @path = File.join(File.expand_path("~"), FILE_NAME)
        @data = load_configuration
      end

      def set_key(api_key)
        data[:api_key] = api_key
        write_api_key_to_file
      end

      def self.api_key
        new.data[:api_key]
      end

      def self.set_key(api_key)
        new.set_key(api_key)
      end

      private

      def load_configuration
        YAML.load_file(path)
      rescue Errno::ENOENT
        default_configuration
      end

      def default_configuration
        { api_key: nil }
      end

      def write_api_key_to_file
        File.open(path, File::RDWR | File::TRUNC | File::CREAT, 0o0600) do |rc|
          rc.write(data.to_yaml)
        end
      end
    end
  end
end
