module Digicert
  module CLI
    class CSR < Digicert::CLI::Base
      def fetch
        if order
          order.certificate.csr
        end
      end

      def generate
        if order
          generate_csr_for(order)
        end
      end

      private

      attr_reader :rsa_key

      def extract_local_attributes(options)
        @rsa_key = options.fetch(:key, nil)
      end

      def order
        @order ||= Digicert::Order.fetch(order_id)
      end

      def generate_csr_for(order)
        if rsa_key && File.exists?(rsa_key)
          Digicert::CSRGenerator.generate(csr_attributes(order))
        end
      end

      def csr_attributes(order)
        Hash.new.tap do |csr|
          csr[:rsa_key] = File.read(rsa_key)
          csr[:organization] = order.organization
          csr[:common_name] =
            options[:common_name] || order.certificate.common_name

          if options[:san]
            csr[:san_names] = options[:san]
          end
        end
      end
    end
  end
end
