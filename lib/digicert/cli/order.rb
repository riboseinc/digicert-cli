require "digicert/cli/filter_builder"

module Digicert
  module CLI
    class Order < Digicert::CLI::Base
      def list
        display_orders_in_table(orders)
      end

      def find
        apply_ouput_flag(orders.first)
      end

      private

      def orders
        @orders ||= order_api.all(filter_options)
      end

      def order_api
        Digicert::Order
      end

      def filter_options
        if options[:filter]
          { filters: Digicert::CLI::FilterBuilder.build(options[:filter]) }
        end
      end

      def apply_ouput_flag(order)
        options[:quiet] ? order.id : order
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
