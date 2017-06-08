require "optparse"
require "digicert/cli/csr"
require "digicert/cli/order"
require "digicert/cli/certificate"

module Digicert
  module CLI
    module Command
      def self.run(command, subcommand, args = {})
        command_klass = command_handler(command)
        attributes = parse_option_arguments(command_klass, args)

        command_klass.new(attributes).send(subcommand.to_sym)
      end

      def self.parse(command)
        command_handlers[command.to_sym] || raise(ArgumentError)
      end

      def self.command_handlers
        @commands ||= { order: "Order", csr: "CSR", certificate: "Certificate" }
      end

      def self.command_handler(command)
        Object.const_get(
          ["Digicert", "CLI", parse(command)].join("::")
        )
      end

      def self.parse_option_arguments(handler_klass, args)
        attributes = {}

        option_parser = OptionParser.new do |parser|
          parser.banner = "Usage: digicert resource action [options]"
          options = global_options + handler_klass.local_options

          options.each do |option|
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
          ["-c", "--common_name COMMON_NAME", "The domain name"],
          ["-o", "--order_id ORDER_ID",  "The Digicert Order Id"],
        ]
      end
    end
  end
end
