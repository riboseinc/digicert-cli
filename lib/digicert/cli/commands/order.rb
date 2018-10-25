require "digicert/cli/order"
require "digicert/cli/order_reissuer"
require "digicert/cli/order_creator"

module Digicert
  module CLI
    module Commands
      class Order < Thor
        desc "list", "List digicert orders"
        method_option :filter, type: :hash, desc: "Specify filter options"

        def list
          say(order_instance.list)
        end

        desc "find", "Find a digicert order"
        method_option :filter, type: :hash, desc: "Specify filter options"
        option :quiet, type: :boolean, aliases: "-q", desc: "Retrieve only id"

        def find
          say(order_instance.find)
        end

        desc "reissue ORDER_ID", "Reissue digicert order"
        option :csr, desc: "The CSR content from a file"
        option :output, aliases: "-o", desc: "Path to download certificates"

        def reissue(order_id)
          say(reissue_an_order(order_id))
        end

        desc "create NAME_ID", "Create a new order"
        method_option :csr, desc: "The CSR content from a file"
        method_option :common_name, desc: "Certificate Common Name"
        method_option :signature_hash, desc: "Certificate signature hash"
        method_option :organization_id, desc: "The Organization ID"
        method_option :validity_years, desc: "Validity years for certificate"
        method_option :comments, desc: "Comments about the certificate order"
        method_option :payment_method, desc: "Speicfy the payment method"

        method_option :disable_renewal_notifications, type: :boolean
        method_option :server_platform_id, desc: "Server Platform Id"
        method_option :profile_option, desc: "Specify certificate profile"
        method_option :organization_units, type: :array, desc: "organization_units"
        method_option :custom_expiration_date, desc: "Expiry Date in YYY-MM-DD"
        method_option :renewal_of_order_id, desc: "Id for renewalable Order"
        method_option :disable_ct, type: :boolean, desc: "Disable CT logging"

        def create(name_id)
          order = create_new_order(name_id, options)
          say("New Order Created! Oder Id: #{order.id}.")

        rescue Digicert::Errors::RequestError => error
          say("Request Error: #{error}.")
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

        def create_new_order(name_id, options)
          Digicert::CLI::OrderCreator.create(name_id, options)
        end
      end
    end
  end
end
