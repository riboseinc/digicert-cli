require "spec_helper"

RSpec.describe "CSR" do
  describe "fetching a CSR" do
    it "fetches the CSR for specified order" do
      command = %w(csr fetch --order_id 123456)
      allow(Digicert::CLI::CSR).to receive_message_chain(:new, :fetch)

      Digicert::CLI.start(*command)

      expect(Digicert::CLI::CSR).to have_received(:new).with(order_id: "123456")
    end
  end

  describe "generating CSR" do
    it "generates a new CSR for an existing order" do
      allow(Digicert::CLI::CSR).to receive_message_chain(:new, :generate)
      command = %w(csr generate -o 123456 --key ./spec/fixtures/rsa4096.key)

      Digicert::CLI.start(*command)

      expect(Digicert::CLI::CSR).to have_received(:new).with(
        order_id: "123456", key: "./spec/fixtures/rsa4096.key"
      )
    end
  end
end
