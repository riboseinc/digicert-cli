require "spec_helper"

RSpec.describe "Order duplicating" do
  describe "duplicate an order" do
    context "duplicate with new csr" do
      it "duplicate an order with provided csr" do
        mock_digicert_order_duplication_message_chain
        command = %w(order duplicate 123456 --csr ./spec/fixtures/rsa4096.csr)

        _output = capture_stdout { Digicert::CLI.start(command) }

        expect(Digicert::CLI::OrderDuplicator).to have_received(:new).
          with(order_id: "123456", csr: "./spec/fixtures/rsa4096.csr")
      end
    end
  end

  def mock_digicert_order_duplication_message_chain
    allow(Digicert::CLI::OrderDuplicator).
      to receive_message_chain(:new, :create)
  end
end
