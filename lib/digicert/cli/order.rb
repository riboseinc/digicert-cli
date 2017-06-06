require "digicert/cli/order_filterer"
require "digicert/cli/order_reissuer"

module Digicert
  module CLI
    class Order < Digicert::CLI::Base
      def list
        filtered_orders = apply_filters(orders)
        display_orders_in_table(filtered_orders)
      end

      def find
        filtered_orders = apply_filters(orders)
        apply_ouput_flag(filtered_orders.first)
      end

      def reissue
        Digicert::CLI::OrderReissuer.new(
          order_id: order_id, **options
        ).create
      end

      def self.local_options
        [
          ["-q", "--quiet",  "Flag to return resource Id only"],
          ["-s", "--status STATUS", "Use to specify the order status"],
          ["-n", "--product_type NAME_ID", "The Digicert product name Id"],
          ["-f", "--fetch", "Flag to fetch resource after certian operation"],
          ["-r", "--crt CSR_FILE", "Full path for the csr file"],
          ["-p", "--output DOWNLOAD_PATH", "Path to download the certificate"]
        ]
      end

      private

      def orders
        @orders ||= order_api.all
      end

      def order_api
        Digicert::Order
      end

      def apply_filters(orders)
        Digicert::CLI::OrderFilterer.filter(orders, options)
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
