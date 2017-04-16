require "optparse"
require "digicert/cli/command/order"

module Digicert
  module CLI
    module Command
      def self.load
        register_available_commands
      end

      def self.run(command, args = {})
        command_klass, method = extract_command(command)
        attributes = parse_option_arguments(args)

        command_klass.new(attributes).send(method || :list)
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

      def self.parse_option_arguments(args)
        attributes = {}

        option_parser = OptionParser.new do |parser|
          parser.banner = "Usage: digicert resource:action [options]"

          global_options.each do |option|
            attribute_name = option[1].split.first.gsub("--", "").to_sym
            parser.on(*option) { |value| attributes[attribute_name] = value}
          end
        end

        if args.first
          option_parser.parse!(args)
        end

        attributes
      end

      def self.global_options
        [
          ["-o", "--order_id ORDER_ID",  "The Digicert Order Id"],
          ["-c", "--common_name COMMON_NAME", "The common name for the order"],
          ["-p", "--product_type NAME_ID", "The Digicert product name Id"],
        ]
      end
    end
  end
end
