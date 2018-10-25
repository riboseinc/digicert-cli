require "spec_helper"

RSpec.describe Digicert::CLI::OrderCreator do
  describe ".create" do
    context "with valid order information" do
      it "creates a new digicert certificate order" do
        name_id = "ssl_plus"
        stub_digicert_order_create_api(
          name_id, rest_order_attributes(order_attributes)
        )

        order = Digicert::CLI::OrderCreator.create(name_id, order_attributes)

        expect(order.id).not_to be_nil
        expect(order.requests.first.status).to eq("pending")
      end
    end
  end

  def order_attributes
    @order_attributes ||= {
      common_name: "ribosetest.com",
      csr: "./spec/fixtures/rsa4096.csr",
      signature_hash: "sha512",
      organization_units: "Developer Units",
      server_platform_id: "platform_id_101",
      profile_option: "certificate-profile",
      organization_id: "organization-id",
      validity_years: 3,
      custom_expiration_date: "11-11-2019",
      comments: "Ordered using digicert CLI",
      disable_renewal_notifications: false,
      renewal_of_order_id: 123456,
      payment_method: "balanace",
      disable_ct: false,
    }
  end

  def rest_order_attributes(attributes)
    {
      certificate: {
        organization_units: attributes[:organization_units],
        server_platform: { id: attributes[:server_platform_id] },
        profile_option: attributes[:profile_option],
        csr: File.read(attributes[:csr]),
        common_name: attributes[:common_name],
        signature_hash: attributes[:signature_hash],
      },

      organization: { id: attributes[:organization_id] },
      validity_years: attributes[:validity_years],
      custom_expiration_date: attributes[:custom_expiration_date],
      comments: attributes[:comments],
      disable_renewal_notifications: attributes[:disable_renewal_notifications],
      renewal_of_order_id: attributes[:renewal_of_order_id],
      payment_method: attributes[:payment_method],
      disable_ct: attributes[:disable_ct],
    }
  end
end
