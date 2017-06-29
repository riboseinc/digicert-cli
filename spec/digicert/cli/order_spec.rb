require "spec_helper"

RSpec.describe Digicert::CLI::Order do
  describe "#list" do
    context "without order_id attributes" do
      it "sends all message to digicert order interface" do
        allow(Digicert::Order).to receive(:all).and_return([])

        order = Digicert::CLI::Order.new
        order.list

        expect(Digicert::Order).to have_received(:all)
      end
    end
  end

  describe "#find" do
    context "without any option" do
      it "returns the first filtered order from digicert" do
        common_name = "digicert.com"
        stub_digicert_order_list_api

        order = Digicert::CLI::Order.new(common_name: common_name).find

        expect(order.id).not_to be_nil
        expect(order.certificate.common_name).to eq(common_name)
      end
    end

    context "with quiet option" do
      it "only returns the id from the order" do
        common_name = "digicert.com"
        stub_digicert_order_list_api

        order_id = Digicert::CLI::Order.new(
          common_name: common_name, quiet: true,
        ).find

        expect(order_id).to be_a(Integer)
      end
    end
  end
end
