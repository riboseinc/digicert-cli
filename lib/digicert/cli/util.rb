require "digicert"
require "terminal-table"

module Digicert
  module CLI
    module Util
      def self.make_it_pretty(headings:, rows:)
        Terminal::Table.new do |table|
          table.headings = headings
          table.rows = rows
        end
      end

      def self.say(message, color = nil)
        Thor::Shell::Basic.new.say(message, color)
      end

      def self.run(arguments)
        if arguments.include?("--debug")
          arguments.delete("--debug")

          Digicert.configuration.debug_mode = true
          Digicert::CLI::Command.start(arguments)
          Digicert.configuration.debug_mode = true
        else

          Digicert::CLI::Command.start(arguments)
        end
      end
    end
  end
end
