module Digicert
  module CLI
    class CSR
      def initialize(order_id:)
        @order_id = order_id
      end

      def fetch
        if order
          order.certificate.csr
        end
      end

      private

      attr_reader :order_id

      def order
        @order ||= Digicert::Order.fetch(order_id)
      end
    end
  end
end
