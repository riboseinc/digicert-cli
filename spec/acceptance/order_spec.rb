require "spec_helper"

RSpec.describe "Order" do
  describe "listing orders" do
    it "retrieves the list of the orders" do
      command = %w(order list --filter common_name:*.ribostetest.com)

      allow(Digicert::CLI::Order).to receive_message_chain(:new, :list)
      _output = capture_stdout { Digicert::CLI.start(command) }

      expect(Digicert::CLI::Order.new).to have_received(:list)
    end
  end

  describe "finding an order" do
    it "finds a specific order based on the filters params" do
      command = %w(order find --filter common_name:ribosetest.com)

      allow(Digicert::CLI::Order).to receive_message_chain(:new, :find)
      _output = capture_stdout { Digicert::CLI.start(command) }

      expect(Digicert::CLI::Order.new).to have_received(:find)
    end
  end

  describe "creating an order" do
    context "with valid information" do
      it "creates a new certificate order" do
        allow(
          Digicert::CLI::OrderCreator,
        ).to receive(:create).and_return(double("order", id: 123_456))

        command = %w(
          order create ssl_plus
            --csr ./spec/fixtures/rsa4096.csr
            --common-name ribosetest.com
            --signature-hash sha512
            --organization-id 123456
            --validity-years 3
            --payment-method card
        )

        output = capture_stdout { Digicert::CLI.start(command) }

        expect(output).to include("New Order Created! Oder Id")
        expect(Digicert::CLI::OrderCreator).to have_received(:create).
          with(
            "ssl_plus",
            "csr" => "./spec/fixtures/rsa4096.csr",
            "common_name" => "ribosetest.com",
            "signature_hash" => "sha512",
            "organization_id" => "123456",
            "validity_years" => "3",
            "payment_method" => "card",
          )
      end
    end
  end
end
