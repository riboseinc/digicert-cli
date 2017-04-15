require "digicert"
require "digicert/cli/auth"

module Digicert
  module CLI
    def self.start(*arguments)
      puts arguments.inspect
    end
  end
end
