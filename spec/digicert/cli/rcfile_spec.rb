require "spec_helper"

RSpec.describe Digicert::CLI::RCFile do
  describe ".set_key" do
    it "writes the api key to the configuration file" do
      secret_api_key = "super_secret_key"
      allow(File).to receive(:expand_path).and_return(fixtures_path)

      Digicert::CLI::RCFile.set_key(secret_api_key)

      expect(Digicert::CLI::RCFile.api_key).to eq(secret_api_key)
    end
  end

  def fixtures_path
    File.expand_path("../../../fixtures", __FILE__)
  end
end
