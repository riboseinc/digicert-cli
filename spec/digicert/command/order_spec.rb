require "spec_helper"

RSpec.describe Digicert::CLI::Command do
  describe "#list" do
    it "sends all message to digicert order interface" do
      allow(Digicert::Order).to receive(:all)

      order = Digicert::CLI::Command::Order.new
      order.list

      expect(Digicert::Order).to have_received(:all)
    end
  end
end
