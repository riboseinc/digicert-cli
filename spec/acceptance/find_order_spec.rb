require "spec_helper"

RSpec.describe "Find an order" do
  describe "finding an order" do
    it "retrieves a specific order from digicert" do
      command = %w(find-order)

      allow($stdout).to receive(:write)
      allow(Digicert::Order).to receive(:all).and_return([])

      Digicert::CLI.start(*command)

      expect(Digicert::Order).to have_received(:all)
    end
  end
end
