require 'date'

module Mpx
  ##
  # Manages history for commands.
  class History
    def initialize(root)
      @root = root

      FileUtils.mkdir_p(@root)
    end

    def now
      return DateTime.now.strftime("%d/%m/%Y %H:%M")
    end

    def get(*commands)
      lines = commands.length.zero? ? get_all : commands
        .map { |c| get_one(c) }
        .flatten

      return lines.sort_by do |line|
        time, * = line.split('$')
        DateTime.parse(time.strip)
      end
    end

    def get_all
      return Dir.entries(@root)
        .select { |f| File.file?(File.join(@root, f)) }
        .map { |file| get_one(file) }
        .flatten
    end

    def get_one(command)
      File.foreach(File.join(@root, command))
        .map { |line| line.strip }
    rescue
      raise "no history for #{command}"
    end

    def write(command, *args)
      File.open(File.join(@root, command), 'a') do |f|
        f.puts("#{now} $ #{command} #{args.join(' ')}")
      end
    end
  end
end
