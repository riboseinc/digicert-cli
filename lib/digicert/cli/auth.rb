require "digicert"
require "digicert/cli/rcfile"

unless Digicert.configuration.api_key
  Digicert.configure do |config|
    config.api_key = Digicert::CLI::RCFile.api_key || ENV["DIGICERT_API_KEY"]
  end
end
