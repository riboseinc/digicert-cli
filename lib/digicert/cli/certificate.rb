module Digicert
  module CLI
    class Certificate < Digicert::CLI::Base
      def fetch
        apply_ouput_flag(order.certificate)
      end

      def self.local_options
        [
          ["-q", "--quiet",  "Flag to return only the certificate Id"]
        ]
      end

      private

      def order
        @order ||= Digicert::Order.fetch(order_id)
      end

      def apply_ouput_flag(certificate)
        options[:quiet] ? certificate.id : certificate
      end
    end
  end
end
