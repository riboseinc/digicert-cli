require "digicert/cli/rcfile"
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

      desc "config API_KEY", "Configure The CLI Client"
      def config(api_key)
        Digicert::CLI::RCFile.set_key(api_key)
      end
    end
  end
end
