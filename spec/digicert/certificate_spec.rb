require "spec_helper"

RSpec.describe Digicert::CLI::Certificate do
  describe "#fetch" do
    context "with only order id" do
      it "returns the details for the certificate" do
        order_id = 123_456_789
        stub_digicert_order_fetch_api(order_id)

        certificate = Digicert::CLI::Certificate.new(
          order_id: order_id
        ).fetch

        expect(certificate.id).not_to be_nil
        expect(certificate.organization.id).not_to be_nil
        expect(certificate.common_name).to eq("digicert.com")
      end
    end

    context "with option attributes" do
      it "returns the option attribute specified details" do
        order_id = 112_358
        stub_digicert_order_fetch_api(order_id)

        certificate = Digicert::CLI::Certificate.new(
          order_id: order_id, quiet: true
        ).fetch

        expect(certificate).to eq(order_id)
      end
    end

    context "output attribute specified" do
      it "sends download message to certificate downloader" do
        order_id = 112_358

        stub_digicert_order_fetch_api(order_id)
        allow(Digicert::CLI::CertificateDownloader).to receive(:download)

        Digicert::CLI::Certificate.new(
          order_id: order_id, output: "/tmp/downloads",
        ).fetch

        expect(Digicert::CLI::CertificateDownloader).
          to have_received(:download).with({
            certificate_id: 112358, filename: order_id, path: "/tmp/downloads",
        })
      end
    end
  end

  describe "#duplicates" do
    it "lists duplicate certificates" do
      order_id = 112_358
      allow(Digicert::DuplicateCertificate).to receive(:all)

      Digicert::CLI::Certificate.new(order_id: order_id).duplicates

      expect(
        Digicert::DuplicateCertificate,
      ).to have_received(:all).with(order_id: order_id)
    end
  end
end
