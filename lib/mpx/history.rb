module Mpx
  ##
  # Manages history for commands.
  class History
    def initialize(root)
      @root = root

      FileUtils.mkdir_p(@root)
    end

    def now
      return Time.now.strftime("%d/%m/%Y %H:%M")
    end

    def write(command, *args)
      File.open(File.join(@root, command), 'a') do |f|
        f.puts("#{now} $ #{command} #{args.join(' ')}")
      end
    end
  end
end
