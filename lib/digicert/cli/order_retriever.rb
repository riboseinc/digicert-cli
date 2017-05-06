require "date"

module Digicert
  module CLI
    class OrderRetriever
      def initialize(order_id, attributes)
        @order_id = order_id
        @wait_time = attributes[:wait_time] || 10
        @number_of_times = attributes[:number_of_times] || 5
      end

      def fetch
        fetch_order_in_interval
        reissued_order
      end

      def self.fetch(order_id, attributes)
        new(order_id, **attributes).fetch
      end

      private

      attr_reader :order_id, :number_of_times, :wait_time, :reissued_order

      def fetch_order_in_interval
        number_of_times.to_i.times do |number|
          sleep wait_time.to_i
          print_message("Fetch attempt #{number + 1}..")
          order = Digicert::Order.fetch(order_id)

          if recently_reissued?(order.last_reissued_date)
            break @reissued_order = order
          end
        end
      end

      def recently_reissued?(datetime)
        if datetime
          ((Time.now - DateTime.parse(datetime).to_time) / 60).ceil < 3
        end
      end

      def print_message(message)
        Digicert::CLI::Util.print_message(message)
      end
    end
  end
end
