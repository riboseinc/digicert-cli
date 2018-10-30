require "spec_helper"

RSpec.describe "Order reissuing" do
  describe "reissue an order" do
    context "reissue with new csr" do
      it "reissues an order with the provided csr" do
        mock_digicert_order_reissuer_create_message_chain
        command = %w(order reissue 123456 --csr ./spec/fixtures/rsa4096.csr)

        _output = capture_stdout { Digicert::CLI.start(command) }

        expect(Digicert::CLI::OrderReissuer).to have_received(:new).
          with(order_id: "123456", csr: "./spec/fixtures/rsa4096.csr")
      end
    end

    context "reissue and download certificate" do
      it "reissues an order and download the certificate" do
        mock_digicert_order_reissuer_create_message_chain
        command = %w(order reissue 123456 --output /tmp/downloads)

        _output = capture_stdout { Digicert::CLI.start(command) }

        expect(Digicert::CLI::OrderReissuer).to have_received(:new).
          with(order_id: "123456", output: "/tmp/downloads")
      end
    end
  end

  def mock_digicert_order_reissuer_create_message_chain
    allow(Digicert::CLI::OrderReissuer).to receive_message_chain(:new, :create)
  end
end
