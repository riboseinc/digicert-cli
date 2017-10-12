require "digicert/cli/commands/csr"
require "digicert/cli/commands/order"
require "digicert/cli/commands/config"
require "digicert/cli/commands/certificate"

module Digicert
  module CLI
    class Command < Thor
      desc "csr", "Fetch/generate Certificate CSR"
      subcommand :csr, Digicert::CLI::Commands::Csr

      desc "order", "Manage Digicert Orders"
      subcommand :order, Digicert::CLI::Commands::Order

      desc "certificate", "Manage Digicert Certificates"
      subcommand :certificate, Digicert::CLI::Commands::Certificate

      desc "config", "Configure The CLI Client"
      subcommand :config, Digicert::CLI::Commands::Config
    end
  end
end
