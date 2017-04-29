require "spec_helper"

RSpec.describe "Find orders" do
  describe "find existing orders" do
    it "retrieves the list of the orders" do
      command = %w(find-orders -c *.ribostetest.com -p ssl_wildcard)

      allow($stdout).to receive(:write)
      allow(Digicert::Order).to receive(:all).and_return([])

      Digicert::CLI.start(*command)

      expect(Digicert::Order).to have_received(:all)
    end
  end
end
