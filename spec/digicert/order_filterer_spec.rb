require "spec_helper"
require "digicert/cli/order_filterer"

RSpec.describe Digicert::CLI::OrderFilterer do
  describe ".filter" do
    context "with common name filter" do
      it "it filters the collection by common name" do
        common_name = "digicert.com"

        orders = Digicert::CLI::OrderFilterer.filter(
          orders_double, common_name: common_name
        )

        expect(orders.count).to eq(3)
        expect(orders.first.certificate.common_name).to eq(common_name)
      end
    end

    context "with product type filter" do
      it "filters the collection by product type" do
        product_type = "ssl_plus"

        orders = Digicert::CLI::OrderFilterer.filter(
          orders_double, product_type: product_type
        )

        expect(orders.count).to eq(3)
        expect(orders.first.product.name_id).to eq(product_type)
      end
    end

    context "with order status filter" do
      it "filters the collection by specified status" do
        order_status = "needs_approval"

        orders = Digicert::CLI::OrderFilterer.filter(
          orders_double, status: order_status
        )

        expect(orders.count).to eq(2)
        expect(orders.first.status).to eq(order_status)
      end
    end
  end

  def orders_double
    stub_digicert_order_list_api
    @orders ||= Digicert::Order.all
  end
end
