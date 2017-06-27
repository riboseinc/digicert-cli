require "thor"
require "openssl"
require "digicert"

require "digicert/cli/util"
require "digicert/cli/auth"
require "digicert/cli/base"
require "digicert/cli/command"

module Digicert
  module CLI
    def self.start(arguments)
      Digicert::CLI::Command.start(arguments)
    rescue Digicert::Errors::Forbidden, NoMethodError
      Thor::Shell::Basic.new.say(
        "Invalid: Missing API KEY\n\n" \
        "A valid Digicert API key is required for any of the CLI operation\n" \
        "You can set your API Key using `digicert config DIGICERT_API_KEY`",
      )
    end
  end
end
