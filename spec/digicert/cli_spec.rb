require "spec_helper"

RSpec.describe Digicert::CLI do
  describe ".start" do
    it "sends run message to command handler" do
      shell_command = %w(order:find -n order_id)
      allow(Digicert::CLI::Command).to receive(:run)

      Digicert::CLI.start(*shell_command)

      expect(
        Digicert::CLI::Command,
      ).to have_received(:run).with(shell_command.shift, shell_command)
    end
  end
end
