module Digicert
  module CLI
    module Command
      class Certificate
        attr_reader :order_id, :options

        def initialize(attributes = {})
          @options = attributes
          @order_id = options[:order_id]
        end

        def retrieve
          if order_id
            downloader_klass.fetch_content(order_id)
          end
        end

        private

        def downloader_klass
          Digicert::CertificateDownloader
        end
      end
    end
  end
end
