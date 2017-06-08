module Digicert
  module CLI
    class Certificate < Digicert::CLI::Base
      def fetch
        apply_option_flags(order.certificate)
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
    end
  end
end
