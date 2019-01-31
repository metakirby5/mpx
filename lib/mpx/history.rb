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

    def all_history
      return Dir.entries(@root)
        .select { |f| File.file?(File.join(@root, f)) }
    end

    def get(*commands)
      return (commands.empty? ? all_history : commands)
        .map { |c| history_for(c) }
        .flatten
        .sort_by do |line|
          time, * = line.split('$')
          DateTime.parse(time.strip)
        end
    end

    def history_for(command)
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
