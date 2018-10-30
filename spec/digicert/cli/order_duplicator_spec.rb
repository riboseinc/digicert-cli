require "spec_helper"

RSpec.describe Digicert::CLI::OrderDuplicator do
  describe "#create" do
    context "with a valid order id" do
      it "sends create message to digicert order duplicator" do
        order_id = 123_456
        allow(Digicert::OrderDuplicator).to receive(:create)

        Digicert::CLI::OrderDuplicator.new(order_id: order_id).create

        expect(
          Digicert::OrderDuplicator,
        ).to have_received(:create).with(order_id: order_id)
      end
    end

    context "with order id and new csr" do
      it "sends create message to duplicator with new csr" do
        order_id = 123_456
        csr_file = "./spec/fixtures/rsa4096.csr"
        allow(Digicert::OrderDuplicator).to receive(:create)

        Digicert::CLI::OrderDuplicator.new(
          order_id: order_id, csr: csr_file,
        ).create

        expect(Digicert::OrderDuplicator).to have_received(:create).with(
          order_id: order_id, csr: File.read(csr_file),
        )
      end
    end

    context "with order id and --fetch option" do
      it "duplicates order and fetch the updated order" do
        order_id = 456_789

        mock_order_fetch_and_download_requests(order)
        stub_digicert_order_duplicate_api(order_id, order_attributes(order))
        allow(Digicert::CLI::CertificateDownloader).to receive(:download)

        Digicert::CLI::OrderDuplicator.new(
          order_id: order_id, output: "/tmp", number_of_times: 1, wait_time: 1,
        ).create

        expect(Digicert::CLI::CertificateDownloader).
          to have_received(:download).
          with(hash_including(certificate_id: order.certificate.id))
      end
    end

    def order(order_id = 123_456)
      stub_digicert_order_fetch_api(order_id)
      @order ||= Digicert::Order.fetch(order_id)
    end

    def order_attributes(order)
      {
        common_name: order.certificate.common_name,
        dns_names: order.certificate.dns_names,
        csr: order.certificate.csr,
        signature_hash: order.certificate.signature_hash,
        server_platform: { id: 45 },
      }
    end

    def mock_order_fetch_and_download_requests(order)
      allow(Digicert::Order).to receive(:fetch).and_return(order)

      allow(
        Digicert::DuplicateCertificateFinder,
      ).to receive(:find_by).and_return(order.certificate)
    end
  end
end
