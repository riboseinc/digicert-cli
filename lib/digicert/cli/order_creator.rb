module Digicert
  module CLI
    class OrderCreator < Digicert::CLI::Base
      def initialize(name_id, attributes)
        @name_id = name_id
        @attributes = attributes
      end

      def create
        create_order
      end

      def self.create(name_id, attributes)
        new(name_id, attributes).create
      end

      private

      attr_reader :name_id, :attributes

      def create_order
        Digicert::Order.create(name_id, order_attributes)
      end

      def csr_file_content(csr_file)
        if csr_file && File.exists?(csr_file)
          File.read(csr_file)
        end
      end

      def organization
        Digicert::Organization.all.last
      end

      def order_attributes
        {
          certificate: {
            common_name: attributes[:common_name],
            csr: csr_file_content(attributes[:csr]),
            signature_hash: attributes[:signature_hash],
            organization_units: attributes[:organization_units],
            server_platform: { id: attributes[:server_platform_id] },
            profile_option: attributes[:profile_option],
          },

          organization: { id: attributes[:organization_id] || organization.id },
          validity_years: attributes[:validity_years] || 3,
          custom_expiration_date: attributes[:custom_expiration_date],
          comments: attributes[:comments],
          disable_renewal_notifications: attributes[:disable_renewal_notifications],
          renewal_of_order_id: attributes[:renewal_of_order_id],
          payment_method: attributes[:payment_method],
          disable_ct: attributes[:disable_ct],
        }
      end
    end
  end
end
