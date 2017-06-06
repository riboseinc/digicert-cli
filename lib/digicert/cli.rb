require "optparse"
require "digicert"

require "digicert/cli/util"
require "digicert/cli/auth"
require "digicert/cli/base"
require "digicert/cli/command"

module Digicert
  module CLI
    def self.start(*args)
      command = args.shift.strip rescue help
      subcommand = args.first.start_with?("-") ? "list" : args.shift.strip

      response = Digicert::CLI::Command.run(command, subcommand, args)

      $stdout.write(response)
      $stdout.write("\n")
    end
  end
end
