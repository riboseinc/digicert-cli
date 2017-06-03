require "optparse"
require "digicert/cli/order"
require "digicert/cli/csr"

module Digicert
  module CLI
    module Command
      def self.run(command, subcommand, args = {})
        command_klass = command_handler(command)
        attributes = parse_option_arguments(args)

        command_klass.new(attributes).send(subcommand.to_sym)
      end

      def self.parse(command)
        command_handlers[command.to_sym] || raise(ArgumentError)
      end

      def self.command_handlers
        @commands ||= { order: "Order", csr: "CSR"}
      end

      def self.command_handler(command)
        Object.const_get(
          ["Digicert", "CLI", parse(command)].join("::")
        )
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
          ["-q", "--quiet",  "Flag to return resource Id only"],
          ["-s", "--status STATUS", "Use to specify the order status"],
          ["-c", "--common_name COMMON_NAME", "The common name for the order"],
          ["-p", "--product_type NAME_ID", "The Digicert product name Id"],
          ["-f", "--fetch", "Flag to fetch resource after certian operation"],
          ["-crt", "--crt CSR_FILE", "Full path for the csr file"],
          ["-path", "--output DOWNLOAD_PATH", "Path to download the certificate"]
        ]
      end
    end
  end
end
