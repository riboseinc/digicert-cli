module Digicert
  module CLI
    class OrderFilterer
      attr_reader :orders

      def initialize(orders:, filters:) @orders = orders
        @status = filters.fetch(:status, nil)
        @common_name = filters.fetch(:common_name, nil)
        @product_type = filters.fetch(:product_type, nil)
      end

      def filter
        orders.select {|order| apply_option_filters(order) }
      end

      def self.filter(orders, filter_options)
        new(orders: orders, filters: filter_options).filter
      end

      private

      attr_reader :status, :common_name, :product_type

      def apply_option_filters(order)
        filter_by_common_name(order) &&
          filter_by_product_type(order) && filter_by_status(order)
      end

      def filter_by_status(order)
        !status || status == order.status
      end

      def filter_by_common_name(order)
        !common_name || common_name == order.certificate.common_name
      end

      def filter_by_product_type(order)
        !product_type || product_type == order.product.name_id
      end
    end
  end
end
