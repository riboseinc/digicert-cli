require "digicert/cli/certificate"

module Digicert
  module CLI
    module Commands
      class Certificate < Thor
        desc "fetch ORDER_ID", "Find an order's certificate"
        option :quiet, type: :boolean, aliases: "-q", desc: "Retrieve only id"
        option :output, aliases: "-o", desc: "Path to download the certificate"

        def fetch(order_id)
          say(certificate_instance(order_id: order_id).fetch)
        end

        desc "download [RSOURCE_OPTION]", "Download a certificate"
        option :order_id, aliases: "-i", desc: "Digicert order ID"
        option :certificate_id, aliases: "-c", desc: "The certificate ID"

        option(
          :output,
          aliases: "-o",
          default: Dir.pwd,
          desc: "Path to download the certificate",
        )

        def download
          required_option_exists? || say(certificate_instance.download)
        rescue Digicert::Errors::RequestError
          say("Invalid Resource ID")
        end

        desc "duplicates ORDER_ID", "List duplicate certificates"
        def duplicates(order_id)
          say(certificate_instance(order_id: order_id).duplicates)
        end

        private

        def certificate_instance(id_attribute = {})
          Digicert::CLI::Certificate.new(options.merge(id_attribute))
        end

        def required_option_exists?
          unless options[:order_id] || options[:certificate_id]
            say("You must provide either `--order_id` or `--certificate_id`.")
          end
        end
      end
    end
  end
end
