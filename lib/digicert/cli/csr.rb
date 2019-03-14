module Digicert
  module CLI
    class CSR < Digicert::CLI::Base
      def fetch
        if order
          order.certificate.csr
        end
      end

      def generate
        if order || valid_data?
          generate_new_csr
        end
      end

      private

      attr_reader :rsa_key, :organization_id, :common_name

      def extract_local_attributes(options)
        @rsa_key = options.fetch(:key, nil)
        @common_name = options.fetch(:common_name, nil)
        @organization_id = options.fetch(:organization_id, nil)
      end

      def valid_data?
        !organization.nil? && !options[:common_name].nil?
      end

      def order
        if order_id
          @order ||= Digicert::Order.fetch(order_id)
        end
      end

      def organization
        if organization_id
          @organization ||= Digicert::Organization.fetch(organization_id)
        end
      end

      def generate_new_csr
        if rsa_key && File.exists?(rsa_key)
          Digicert::CSRGenerator.generate(csr_attributes(order))
        end
      end

      def csr_attributes(order)
        Hash.new.tap do |csr|
          csr[:rsa_key] = File.read(rsa_key)
          csr[:organization] = organization || order.organization
          csr[:common_name] = common_name || order.certificate.common_name

          if options[:san]
            csr[:san_names] = options[:san]
          end
        end
      end
    end
  end
end
