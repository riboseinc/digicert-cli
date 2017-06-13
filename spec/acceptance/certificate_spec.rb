require "spec_helper"

RSpec.describe "Certificate" do
  describe "fetch a certificate" do
    it "returns certificate details for an order" do
      command = %w(certificate fetch --order_id 123456 --quiet)
      allow(Digicert::CLI::Certificate).to receive_message_chain(:new, :fetch)

      Digicert::CLI.start(*command)

      expect(
        Digicert::CLI::Certificate,
      ).to have_received(:new).with(order_id: "123456", quiet: true)
    end
  end

  describe "downloading a certificate" do
    it "downloads the certificate to provided path" do
      command = %w(certificate fetch --order_id 123456 --output /tmp/downloads)
      allow(Digicert::CLI::Certificate).to receive_message_chain(:new, :fetch)

      Digicert::CLI.start(*command)

      expect(Digicert::CLI::Certificate).to have_received(:new).with(
        order_id: "123456", output: "/tmp/downloads"
      )
    end
  end

  describe "listing duplicate certificates" do
    it "returns the list of duplicate certificates" do
      command = %w(certificate duplicates --order_id 123456)

      allow(
        Digicert::CLI::Certificate,
      ).to receive_message_chain(:new, :duplicates)

      Digicert::CLI.start(*command)

      expect(
        Digicert::CLI::Certificate,
      ).to have_received(:new).with(order_id: "123456")
    end
  end

  describe "downloading a certificate" do
    it "downloads the certificate to output path" do
      command = %w(certificate download --certificate_id 123 --output /tmp)

      allow(
        Digicert::CLI::Certificate,
      ).to receive_message_chain(:new, :download)

      Digicert::CLI.start(*command)

      expect(
        Digicert::CLI::Certificate,
      ).to have_received(:new).with(certificate_id: "123", output: "/tmp")
    end
  end
end
