module Digicert
  module CLI
    class OrderFinder
      attr_reader :options

      def initialize(attributes = {})
        @options = attributes
      end

      def list
        orders = order_api.all
        orders = apply_filters(orders)

        display_orders_in_table(orders)
      end

      private

      def order_api
        Digicert::Order
      end

      def apply_filters(orders)
        orders.select do |order|
          filter_by_common_name(order) && filter_by_product_type(order)
        end
      end

      def filter_by_common_name(order)
        !options[:common_name] ||
          options[:common_name] == order.certificate.common_name
      end

      def filter_by_product_type(order)
        !options[:product_type] ||
          options[:product_type] == order.product_name_id
      end

      def display_orders_in_table(orders)
        orders_attribtues = orders.map do |order|
          [
            order.id,
            order.product_name_id,
            order.certificate.common_name,
            order.status,
            order.certificate.valid_till,
          ]
        end

        Digicert::CLI::Util.make_it_pretty(
          rows: orders_attribtues,
          headings: ["Id", "Product Type", "Common Name", "Status", "Expiry"],
        )
      end
    end
  end
end
