module Digicert
  module CLI
    class CSR < Digicert::CLI::Base
      def fetch
        if order
          order.certificate.csr
        end
      end

      def generate
        if order
          generate_csr_for(order)
        end
      end

      def self.local_options
        [
          ["-k", "--key KEY_FILE_PATH", "Path to the rsa key file"],
          ["-r", "--crt CSR_FILE", "Full path for the csr file"]
        ]
      end

      private

      attr_reader :rsa_key

      def extract_local_attributes(options)
        @rsa_key = options.fetch(:key, nil)
      end

      def order
        @order ||= Digicert::Order.fetch(order_id)
      end

      def generate_csr_for(order)
        if rsa_key && File.exists?(rsa_key)
          Digicert::CSRGenerator.generate(
            rsa_key: File.read(rsa_key),
            organization: order.organization,
            common_name: order.certificate.common_name
          )
        end
      end
    end
  end
end
