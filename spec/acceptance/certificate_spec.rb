require "spec_helper"

RSpec.describe "Certificate" do
  describe "fetch a certificate" do
    it "returns certificate details for an order" do
      command = %w(certificate find --order_id 123456 --quiet)
      allow(Digicert::CLI::Certificate).to receive_message_chain(:new, :find)

      Digicert::CLI.start(*command)

      expect(
        Digicert::CLI::Certificate,
      ).to have_received(:new).with(order_id: "123456", quiet: true)
    end
  end
end
