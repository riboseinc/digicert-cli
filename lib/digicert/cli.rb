#--
# Copyright (c) 2017 Ribose Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# ++

require "thor"
require "openssl"
require "digicert"

require "digicert/cli/util"
require "digicert/cli/auth"
require "digicert/cli/base"
require "digicert/cli/command"

module Digicert
  module CLI
    def self.start(arguments)
      Digicert::CLI::Command.start(arguments)
    rescue Digicert::Errors::Forbidden, NoMethodError
      Thor::Shell::Basic.new.say(
        "Invalid: Missing API KEY\n\n" \
        "A valid Digicert API key is required for any of the CLI operation\n" \
        "You can set your API Key using `digicert config api-key YOUR_API_KEY`",
      )
    end
  end
end
