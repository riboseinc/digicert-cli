module Digicert
  module CLI
    class CSR
      def initialize(order_id:, **options)
        @order_id = order_id
        @rsa_key = options.fetch(:key, nil)
      end

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

      private

      attr_reader :order_id, :rsa_key

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
