require "terminal-table"

module Digicert
  module CLI
    module Util
      def self.make_it_pretty(headings:, rows:, table_wdith: 80)
        Terminal::Table.new do |table|
          table.headings = headings
          table.style = { width: table_wdith }

          table.rows = rows
        end
      end
    end
  end
end
