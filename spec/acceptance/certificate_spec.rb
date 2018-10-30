require "spec_helper"

RSpec.describe "Certificate" do
  describe "fetch a certificate" do
    it "returns certificate details for an order" do
      command = %w(certificate fetch 123456 --quiet)
      allow(certificate_klass).to receive_message_chain(:new, :fetch)

      _output = capture_stdout { Digicert::CLI.start(command) }

      expect(certificate_klass.new).to have_received(:fetch)
      expect(certificate_klass).to have_received(:new).with(
        order_id: "123456", quiet: true,
      )
    end
  end

  describe "downloading a certificate" do
    it "downloads the certificate to provided path" do
      command = %w(certificate fetch 123456 --output /tmp/downloads)
      allow(Digicert::CLI::Certificate).to receive_message_chain(:new, :fetch)

      _output = capture_stdout { Digicert::CLI.start(command) }

      expect(Digicert::CLI::Certificate).to have_received(:new).with(
        order_id: "123456", output: "/tmp/downloads"
      )
    end
  end

  describe "listing duplicate certificates" do
    it "returns the list of duplicate certificates" do
      command = %w(certificate duplicates 123456)

      allow(
        Digicert::CLI::Certificate,
      ).to receive_message_chain(:new, :duplicates)

      _output = capture_stdout { Digicert::CLI.start(command) }

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

      _output = capture_stdout { Digicert::CLI.start(command) }

      expect(
        Digicert::CLI::Certificate,
      ).to have_received(:new).with(certificate_id: "123", output: "/tmp")
    end
  end

  def certificate_klass
    Digicert::CLI::Certificate
  end
end
