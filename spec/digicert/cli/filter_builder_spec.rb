require "spec_helper"

RSpec.describe Digicert::CLI::FilterBuilder do
  describe ".build" do
    context "normal filter options" do
      it "builds filters only with valid attributes" do
        options = { status: "pending", invalid: "invalid", search: "" }
        filters = Digicert::CLI::FilterBuilder.build(options)

        expect(filters).to eq("status" => "pending")
      end
    end

    context "filter values as an array" do
      it "builds the valid filters properly" do
        options = { status: "pending,active", search: "s" }
        filters = Digicert::CLI::FilterBuilder.build(options)

        expect(filters).to eq(
          "status" => { "0" => "pending", "1" => "active" }, "search" => "s",
        )
      end
    end
  end
end
