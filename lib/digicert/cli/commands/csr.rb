require "digicert/cli/csr"

module Digicert
  module CLI
    module Commands
      class Csr < Thor
        class_option :debug, type: "boolean", desc: "Enable debug mode"

        desc "fetch ORDER_ID", "Fetch an existing CSR"
        def fetch(order_id)
          say(csr_instance(order_id: order_id).fetch)
        end

        desc "generate", "Generate certificate CSR"
        option :order_id, aliases: "-o", desc: "An Order ID"
        option :common_name, aliases: "-c", desc: "The common name"
        option :organization_id, desc: "Your digicert's organization ID"
        option :san, type: :array, desc: "The subject alternative names"
        option :key, aliases: "-k", desc: "Complete path to the rsa key file"

        def generate
          say(csr_instance.generate)
        end

        private

        def csr_instance(id_attribute = {})
          Digicert::CLI::CSR.new(options.merge(id_attribute))
        end
      end
    end
  end
end
