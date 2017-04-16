module Digicert
  module CLI
    module Command
      class Order
        attr_reader :order_id, :options

        def initialize(attributes = {})
          @options = attributes
          @order_id = options[:order_id]
        end

        def list
          find_order || order_api.all
        end

        def find
          find_order || filter_order
        end

        private

        def find_order
          if order_id
            order_api.fetch(order_id)
          end
        end

        def filter_order
          list.select do |order|
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

        def order_api
          Digicert::Order
        end
      end
    end
  end
end
