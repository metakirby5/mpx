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
      @history = File.join(root, HistoryFolder)

      FileUtils.mkdir_p(@bin)
      FileUtils.mkdir_p(@spaces)
      FileUtils.mkdir_p(@sets)
      FileUtils.mkdir_p(@history)

      @history_obj = History.new(@history)
    end

    def load(name)
      return load_all if name.nil?
      return [load_command(name)] rescue load_set(name)
    end

    def load_all
      return Dir.entries(@bin)
        .select { |f| File.file?(File.join(@bin, f)) }
        .map { |file| load_command(file) }
    end

    def load_command(command)
      bin_path = File.join(@bin, command)
      if !File.exist?(bin_path)
        raise "no command found with name `#{command}`"
      end

      space_path = File.join(@spaces, command)
      FileUtils.mkdir_p(space_path)

      return Command.new(bin_path, space_path)
    end

    def load_set(set)
      set_path = File.join(@sets, set)
      if !File.exist?(set_path)
        raise "no command or set found with name `#{set}`"
      end

      return File.foreach(set_path)
        .uniq
        .map { |line| load_command(line.strip) }
    end

    def history
      @history_obj
    end
  end
end
