require "optparse"
require "digicert"

require "digicert/cli/auth"
require "digicert/cli/command"

module Digicert
  module CLI
    def self.start(*args)
      command = args.shift.strip rescue "help"

      Digicert::CLI::Command.load
      response = Digicert::CLI::Command.run(command, args)

      $stdout.write(response)
    end
  end
end
