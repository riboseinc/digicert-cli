require "spec_helper"

RSpec.describe Digicert::CLI::OrderFinder do
  describe "#list" do
    context "without order_id attributes" do
      it "sends all message to digicert order interface" do
        allow(Digicert::Order).to receive(:all).and_return([])

        order = Digicert::CLI::OrderFinder.new
        order.list

        expect(Digicert::Order).to have_received(:all)
      end
    end
  end
end
