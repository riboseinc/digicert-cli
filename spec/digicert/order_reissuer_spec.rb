require "spec_helper"

RSpec.describe Digicert::CLI::OrderReissuer do
  describe "#create" do
    context "with only order id passed" do
      it "sends create message to digicert order reissuer" do
        order_id = 123_456
        allow(Digicert::OrderReissuer).to receive(:create)

        reissuer = Digicert::CLI::OrderReissuer.new(order_id: order_id)
        reissuer.create

        expect(
          Digicert::OrderReissuer
        ).to have_received(:create).with(order_id: order_id)
      end
    end
  end
end
