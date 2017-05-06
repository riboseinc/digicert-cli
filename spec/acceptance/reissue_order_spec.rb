require "spec_helper"

RSpec.describe "Reissue order" do
  describe "Reissuing an existing order" do
    it "reissues the order and print out the details" do
      command = %w(reissue-order --order_id 123456)
      allow(Digicert::OrderReissuer).to receive(:create)

      Digicert::CLI.start(*command)

      expect(
        Digicert::OrderReissuer,
      ).to have_received(:create).with(order_id: "123456")
    end
  end
end
