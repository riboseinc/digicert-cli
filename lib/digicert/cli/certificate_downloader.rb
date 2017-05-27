module Digicert
  module CLI
    class CertificateDownloader
      def initialize(certificate_id:, path:, **options)
        @path = path
        @options = options
        @certificate_id = certificate_id
        @filename = options.fetch(:filename, certificate_id)
      end

      def download
        if certificate_contents
          write_certificate_contents(certificate_contents)
        end
      end

      def self.download(attributes)
        new(attributes).download
      end

      private

      attr_reader :certificate_id, :path, :filename, :options

      def certificate_contents
        @certificate_contents ||=
          Digicert::CertificateDownloader.fetch_content(certificate_id)
      end

      def write_certificate_contents(contents)
        print_message("Downloaded certificate to:")

        write_to_path("root", contents[:root_certificate])
        write_to_path("certificate", contents[:certificate])
        write_to_path("intermediate", contents[:intermediate_certificate])
      end

      def write_to_path(key, content)
        certificate_name = [filename, key, "crt"].join(".")
        certificate_path = [path, certificate_name].join("/")

        print_message(certificate_path)
        File.open(certificate_path, "w") { |file| file.write(content) }
      end

      def print_message(message)
        if options.fetch(:print_enable, true)
          puts(message)
        end
      end
    end
  end
end
