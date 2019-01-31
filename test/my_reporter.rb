require 'ansi/code'

module Minitest
  module Reporters
    class MyReporter < BaseReporter
      include ANSI::Code
      include RelativePosition

      def start
        super
        puts
      end

      def record(test)
        super
        if !test.skipped? and test.failure
          puts "#{red {'FAIL'}} #{test.class_name}: #{test.name[10..-1]}"
          puts pad_test test.failure.message
          puts test.failure.location
          puts
        end
      end

      def report
        super
        puts "#{count - skips}/#{count} tests"

        color = failures.zero? && errors.zero? ? :green : :red
        puts send(color) { "#{failures} failures" }

        puts
      end
    end
  end
end
