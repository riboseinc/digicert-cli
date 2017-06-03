require "spec_helper"

RSpec.describe Digicert::CLI::CSR do
  describe "#fetch" do
    it "fetches the csr for an existing order" do
      order_id = 123456
      stub_digicert_order_fetch_api(order_id)

      csr = Digicert::CLI::CSR.new(order_id: order_id).fetch

      expect(csr).not_to be_nil
      expect(csr).to eq("------ [CSR HERE] ------")
    end
  end
end
