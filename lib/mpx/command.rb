require 'open3'
require 'fileutils'

require 'mpx/result'

module Mpx
  ##
  # Represents a command to be run.
  class Command
    def initialize(bin, working_directory)
      @bin = bin
      @working_directory = working_directory
    end

    def name
      return File.basename(@bin)
    end

    def run(args)
      Dir.chdir(@working_directory) {
        return Result.new(*Open3.capture2e(@bin, *args))
      }
    end
  end
end
