module Digicert
  module CLI
    class Certificate < Digicert::CLI::Base
      def fetch
        apply_option_flags(order.certificate)
      end

      def duplicates
        if order_id && duplicate_certificates
          display_in_table(duplicate_certificates)
        end
      end

      def self.local_options
        [
          ["-q", "--quiet",  "Flag to return only the certificate Id"],
          ["-p", "--output DOWNLOAD_PATH", "Path to download the certificate"]
        ]
      end

      private

      attr_reader :output_path

      def extract_local_attributes(options)
        @output_path = options.fetch(:output, nil)
      end

      def order
        @order ||= Digicert::Order.fetch(order_id)
      end

      def duplicate_certificates
        @certificates ||= Digicert::DuplicateCertificate.all(order_id: order_id)
      end

      def apply_option_flags(certificate)
        download(certificate) || apply_output_flag(certificate)
      end

      def download(certificate)
        if output_path
          Digicert::CLI::CertificateDownloader.download(
            path: output_path, filename: order_id, certificate_id: certificate.id
          )
        end
      end

      def apply_output_flag(certificate)
        options[:quiet] ? certificate.id : certificate
      end

      def display_in_table(certificates)
        certificates_attributes = certificates.map do |certificate|
          [
            certificate.id,
            certificate.common_name,
            certificate.dns_names.join("\n"),
            certificate.status,
            [certificate.valid_from, certificate.valid_till].join(" - "),
          ]
        end

        Digicert::CLI::Util.make_it_pretty(
          table_wdith: 100,
          rows: certificates_attributes,
          headings: ["Id", "Common Name", "SAN Names", "Status", "Validity"],
        )
      end
    end
  end
end
