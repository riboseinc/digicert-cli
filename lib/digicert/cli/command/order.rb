module Digicert
  module CLI
    module Command
      class Order
        attr_reader :order_id

        def initialize(attributes = {})
          @order_id = attributes[:order_id]
        end

        def list
          find_order || order_api.all
        end

        private

        def find_order
          if order_id
            order_api.fetch(order_id)
          end
        end

        def order_api
          Digicert::Order
        end
      end
    end
  end
end
