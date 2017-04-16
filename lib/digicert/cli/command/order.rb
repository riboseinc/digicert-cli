module Digicert
  module CLI
    module Command
      class Order
        attr_reader :options

        def initialize(attributes = {})
          @options = attributes
        end

        def list
          Digicert::Order.all
        end
      end
    end
  end
end
