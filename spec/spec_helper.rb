require "webmock/rspec"
require "digicert/cli"
require "digicert/rspec"

Dir["./spec/support/**/*.rb"].sort.each { |file| require file }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"
  config.include Digicert::ConsoleHelper

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :all do
    Digicert.configure do |digicert_config|
      digicert_config.api_key = ENV["DIGICERT_API_KEY"] || "SECRET_KEY"
    end
  end
end
