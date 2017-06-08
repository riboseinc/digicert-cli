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
  end
end
