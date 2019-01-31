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
      if name.nil?
        return load_all
      end

      return [load_command(name)]
    rescue

      return load_set(name)
    rescue

      raise "no command or set found with name `#{name}`"
    end

    def load_all
      return Dir.entries(@bin)
        .select { |f| File.file?(File.join(@bin, f)) }
        .map { |file| load_command(file) }
        .flatten
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
        raise "no set found with name `#{set}`"
      end

      return File.foreach(set_path)
        .map { |line| load_command(line.strip) }
        .flatten
    end

    def history
      @history
    end
  end
end
