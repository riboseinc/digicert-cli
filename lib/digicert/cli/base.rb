module Digicert
  module CLI
    class Base
      attr_reader :order_id, :options

      def initialize(attributes = {})
        @options = attributes
        @order_id = options.delete(:order_id)

        extract_local_attributes(options)
      end

      def self.local_options
        []
      end

      private

      def extract_local_attributes(options)
      end
    end
  end
end
