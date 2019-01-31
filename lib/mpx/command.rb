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

    def <=>(other)
      return self.name <=> other.name
    end

    def name
      return File.basename(@bin)
    end

    def run(args)
      opened = Open3.capture2e(@bin, *args, :chdir => @working_directory)
      return Result.new(name, *opened)
    end
  end
end
