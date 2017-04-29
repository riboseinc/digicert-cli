require "optparse"
require "digicert"

require "digicert/cli/util"
require "digicert/cli/auth"
require "digicert/cli/command"

module Digicert
  module CLI
    def self.start(*args)
      command = args.shift.strip rescue "help"

      Digicert::CLI::Command.load
      response_body = Digicert::CLI::Command.run(command, args)

      $stdout.write(response_body)
      $stdout.write("\n")
    end
  end
end
