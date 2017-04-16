require "spec_helper"

RSpec.describe Digicert::CLI::Command do
  describe "#list" do
    context "without order_id attributes" do
      it "sends all message to digicert order interface" do
        allow(Digicert::Order).to receive(:all)

        order = Digicert::CLI::Command::Order.new
        order.list

        expect(Digicert::Order).to have_received(:all)
      end
    end

    context "with an order id" do
      it "sends fetch message to digicert order interface" do
        order_id = 123_456_789
        allow(Digicert::Order).to receive(:fetch).and_return("order")

        order = Digicert::CLI::Command::Order.new(order_id: order_id)
        order.list

        expect(Digicert::Order).to have_received(:fetch).with(order_id)
      end
    end
  end
end
