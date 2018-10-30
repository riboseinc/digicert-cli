module Digicert
  module ConsoleHelper
    def capture_stdout(&_block)
      original_stdout = $stdout
      $stdout = fake = StringIO.new

      begin
        yield
      ensure
        $stdout = original_stdout
      end

      fake.string
    end

    def capture_stderr(&_block)
      original_stderr = $stderr
      $stderr = fake = StringIO.new

      begin
        yield
      ensure
        $stderr = original_stderr
      end

      fake.string
    end
  end
end
