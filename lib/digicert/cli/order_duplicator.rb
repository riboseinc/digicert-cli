module Digicert
  module CLI
    class OrderDuplicator < Digicert::CLI::Base
      def create
        apply_output_options(duplicate_an_order)
      end

      private

      attr_reader :csr_file, :output_path

      def extract_local_attributes(options)
        @csr_file = options.fetch(:csr, nil)
        @output_path = options.fetch(:output, "/tmp")
      end

      def duplicate_an_order
        Digicert::OrderDuplicator.create(**order_params)
      end

      def order_params
        Hash.new.tap do |order_params|
          order_params[:order_id] = order_id

          if csr_file && File.exists?(csr_file)
            order_params[:csr] = File.read(csr_file)
          end
        end
      end

      def apply_output_options(duplicate)
        if duplicate
          print_request_details(duplicate.requests.first)
          fetch_and_download_certificate(duplicate.requests.first.id)
        end
      end

      def print_request_details(request)
        Digicert::CLI::Util.say(
          "Duplication request #{request.id} created for order - #{order_id}",
        )
      end

      def fetch_and_download_certificate(request_id)
        if options[:output]
          certificate = fetch_certificate(request_id)
          download_certificate_order(certificate.id)
        end
      end

      def fetch_certificate(request_id)
        Digicert::DuplicateCertificateFinder.find_by(request_id: request_id)
      end

      def download_certificate_order(certificate_id)
        Digicert::CLI::CertificateDownloader.download(
          filename: order_id, path: output_path, certificate_id: certificate_id,
        )
      end
    end
  end
end
