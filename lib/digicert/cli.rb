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
    end
  end
end
