require "webmock/rspec"
require "bundler/setup"
require "digicert/cli"
require "digicert/rspec"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do
    Digicert::CLI::Command.register_available_commands
  end
end
