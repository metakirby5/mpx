$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'minitest/autorun'
require 'minitest/reporters'
require 'my_reporter'

Minitest::Reporters.use! Minitest::Reporters::MyReporter.new
