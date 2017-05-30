require "spec_helper"
require "digicert/cli/order_retriever"

RSpec.describe Digicert::CLI::OrderRetriever do
  describe ".fetch" do
    context "with number_of_times option specfied" do
      it "tries to retrieve the order by specfied number of times" do
        allow(Digicert::Order).to receive(:fetch).and_return(order)

        Digicert::CLI::OrderRetriever.fetch(
          order.id, number_of_times: 2, wait_time: 1
        )

        expect(Digicert::Order).to have_received(:fetch).twice
      end
    end
  end

  def order(order_id = 123_456)
    stub_digicert_order_fetch_api(order_id)
    @order ||= Digicert::Order.fetch(order_id)
  end
end
