require "digicert/cli/rcfile"

module Digicert
  module CLI
    module Commands
      class Config < Thor
        desc "api-key API_KEY", "Configure Your Digicert API Key"
        def api_key(api_key)
          Digicert::CLI::RCFile.set_key(api_key)
        end
      end
    end
  end
end
