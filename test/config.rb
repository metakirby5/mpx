$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'minitest/autorun'
require 'minitest/reporters'
require 'ansi/code'

class MyReporter < Minitest::Reporters::BaseReporter
  include ANSI::Code
  include Minitest::RelativePosition

  def start
    super
    puts
  end

  def record(test)
    super

    if test.skipped?
      return
    end

    if test.failure
      puts "#{red {'FAIL'}} #{test.class_name}: #{test.name[10..-1]}"
      puts pad_test(test.failure.message)
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

Minitest::Reporters.use! MyReporter.new
