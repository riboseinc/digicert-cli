require "spec_helper"

RSpec.describe "CSR" do
  describe "fetching a CSR" do
    it "fetches the CSR for specified order" do
      command = %w(csr fetch 123456)
      allow(Digicert::CLI::CSR).to receive_message_chain(:new, :fetch)

      _output = capture_stdout { Digicert::CLI.start(command) }

      expect(Digicert::CLI::CSR).to have_received(:new).with(order_id: "123456")
    end
  end

  describe "generating CSR" do
    context "with existing order" do
      it "generates a new CSR for an existing order" do
        allow(Digicert::CLI::CSR).to receive_message_chain(:new, :generate)
        command = %w(csr generate -o 123456 --key ./spec/fixtures/rsa4096.key)

        _output = capture_stdout { Digicert::CLI.start(command) }

        expect(Digicert::CLI::CSR).to have_received(:new).with(
          order_id: "123456", key: "./spec/fixtures/rsa4096.key",
        )
      end
    end

    context "with provided details" do
      it "generates a new CSR with the details" do
        command = %w(
          csr generate
          --organization_id 1234
          --common_name ribosetest.com
          --key ./spec/fixtures/rsa4096.key
          --san site1.ribosetest.com site2.ribosetest.com
        )

        allow(Digicert::CLI::CSR).to receive_message_chain(:new, :generate)
        _output = capture_stdout { Digicert::CLI.start(command) }

        expect(Digicert::CLI::CSR).to have_received(:new).with(
          organization_id: "1234",
          common_name: "ribosetest.com",
          key: "./spec/fixtures/rsa4096.key",
          san: ["site1.ribosetest.com", "site2.ribosetest.com"],
        )
      end
    end
  end
end
