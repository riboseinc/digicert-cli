require "digicert/cli/order"
require "digicert/cli/order_reissuer"

module Digicert
  module CLI
    module Commands
      class Order < Thor
        class_option :common_name, aliases: "-c", desc: "The domain name"

        desc "list", "List digicert orders"
        option :product_type, aliases: "-n", desc: "Digicert Name ID"
        option :status, aliases: "-s", desc: "Specify the order status"

        def list
          say(order_instance.list)
        end

        desc "find", "Find a digicert order"
        option :product_type, aliases: "-n", desc: "Digicert Name ID"
        option :status, aliases: "-s", desc: "Specify the order status"
        option :quiet, type: :boolean, aliases: "-q", desc: "Retrieve only id"

        def find
          say(order_instance.find)
        end

        desc "reissue ORDER_ID", "Reissue digicert order"
        option :crt, desc: "The CSR content from a file"
        option :output, aliases: "-o", desc: "Path to download certificates"

        def reissue(order_id)
          say(reissue_an_order(order_id))
        end

        private

        def order_instance
          Digicert::CLI::Order.new(options)
        end

        def reissue_an_order(order_id)
          Digicert::CLI::OrderReissuer.new(
            options.merge(order_id: order_id),
          ).create
        end
      end
    end
  end
end
