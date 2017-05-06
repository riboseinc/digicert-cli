module Digicert
  module CLI
    class OrderReissuer
      attr_reader :order_id, :options

      def initialize(order_id:, **options)
        @order_id = order_id
        @options = options
      end

      def create
        reissue = Digicert::OrderReissuer.create(order_id: order_id)
        apply_output_options(reissue)
      end

      private

      def apply_output_options(reissue)
        if reissue
          request_id = reissue.requests.first.id
          "Reissue request #{request_id} created for order - #{order_id}"
        end
      end
    end
  end
end
