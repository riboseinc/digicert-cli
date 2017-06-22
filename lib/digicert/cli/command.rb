require "digicert/cli/commands/csr"
require "digicert/cli/commands/order"
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
    end
  end
end
