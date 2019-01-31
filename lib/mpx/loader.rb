require 'mpx/command'
require 'mpx/history'

module Mpx
  ##
  # Responsible for path manipulation.
  class Loader
    BinFolder = 'bin'
    SpacesFolder = 'spaces'
    SetsFolder = 'sets'
    HistoryFolder = 'history'

    def initialize(root)
      @bin = File.join(root, BinFolder)
      @spaces = File.join(root, SpacesFolder)
      @sets = File.join(root, SetsFolder)
      @history = History.new(File.join(root, HistoryFolder))
    end

    def load(name)
      command = load_command(name)
      if command
        return [command]
      end

      set = load_set(name)
      if set
        return set
      end

      raise "no command or set found with name `#{name}`"
    end

    def load_command(command)
      bin_path = File.join(@bin, command)
      if !File.exist?(bin_path)
        return nil
      end

      space_path = File.join(@spaces, command)
      FileUtils.mkdir_p(space_path)

      return Command.new(bin_path, space_path)
    end

    def load_set(set)
      set_path = File.join(@sets, set)
      if !File.exist?(set_path)
        return nil
      end

      return File.foreach(set_path).map { |line| load_command(line) }
    end

    def history
      @history
    end
  end
end
