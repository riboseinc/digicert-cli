require "spec_helper"

RSpec.describe "Order" do
  describe "listing orders" do
    it "retrieves the list of the orders" do
      command = %w(order list -c *.ribostetest.com -p ssl_wildcard)

      allow($stdout).to receive(:write)
      allow(Digicert::Order).to receive(:all).and_return([])

      Digicert::CLI.start(*command)

      expect(Digicert::Order).to have_received(:all)
    end
  end

  describe "finding an order" do
    it "finds a specific order based on the filters params" do
      command = %w(order find -c ribosetest.com -s expired)
      allow(Digicert::CLI::Order).to receive_message_chain(:new, :find)

      Digicert::CLI.start(*command)

      expect(Digicert::CLI::Order.new).to have_received(:find)
    end
  end
end
