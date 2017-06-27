module Digicert
  module CLI
    module Util
      # In the test console, printing process related messages creates
      # some unnecessary noices, this module method will temporarily
      # disabled those extra noices from the log.
      #
      def self.say(_message)
      end
    end
  end
end
