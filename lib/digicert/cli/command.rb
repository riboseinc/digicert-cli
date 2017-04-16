require "digicert/cli/command/order"

module Digicert
  module CLI
    module Command
      def self.load
        register_available_commands
      end

      def self.run(command, args = {})
        command_klass, method = extract_command(command)
        command_klass.new(args).send(method)
      end

      def self.parse(command)
        commands[command.to_sym]
      end

      def self.commands
        @@commands ||= {}
      end

      def self.register_available_commands
        commands[:order] = { klass: Digicert::CLI::Command::Order }
      end

      def self.extract_command(command)
        base_command, method = command.split(":")
        [parse(base_command)[:klass], method]
      end
    end
  end
end
