require "spec_helper"

RSpec.describe "Config" do
  describe "configuring key" do
    it "stores the provided api key" do
      command = %w(config api-key DIGICERT_SECRET_KEY)
      allow(Digicert::CLI::RCFile).to receive(:set_key)

      Digicert::CLI.start(command)

      expect(
        Digicert::CLI::RCFile,
      ).to have_received(:set_key).with("DIGICERT_SECRET_KEY")
    end
  end
end
