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
    end
  end
end
