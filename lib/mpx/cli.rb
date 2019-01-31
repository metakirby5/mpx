require 'mpx/request'
require 'mpx/loader'
require 'mpx/version'

module Mpx

  Help = <<-EOF
A command multiplexer.

The root folder MPX_ROOT is an environment variable
which defaults to `~/.local/mpx`.

The following subfolders are used:
- `bin`     Where commands are stored.
- `spaces`  Namespaces for each command.
            Each command receives a subfolder with its name in `spaces`.
            The working directory will be changed to this subfolder before
            command execution.
- `sets`    Aliases to sets of commands. Each file is a set,
            containing newline-delimited commands to run.
- `history` Newline-delimited history of each command/alias, with timestamp.

The first argument is a mandatory operation, and should be one of:

`help`

  Prints this help text.

`version`

  Prints the version.

`history`

  Taking each subsequent argument as a command or set, the history of each
  will be displayed in chronological order.

  If no arguments are provided, the history of all commands and sets
  will be displayed.

A directive in the form of `<COMMAND/SET>:<SUBCOMMAND>` or `:<SUBCOMMAND>`

  In the first form, `<COMMAND/SET>` will be taken as the command or set
  to run with. If names clash, commands will take precedence over sets.
  For a given set, the program will run all commands in the set file.

  In the second form, the program will run with all commands.

  In both forms, `<SUBCOMMAND>` will be passed as the first argument
  to each command. All arguments after the directive will be passed directly.

  If multiple commands run, they shall run in parallel,
  and outputs will be displayed upon completion.
EOF

  ##
  # Command line interface.
  class Cli
    Usage = "Usage: #{File.basename($0)} [operation] [args...]"
    MpxRoot = 'MPX_ROOT'
    DefaultRoot = File.join('.local', 'mpx')

    def self.start
      op, *args = ARGV
      case op
      when 'help'
        self.help
      when 'version'
        self.version
      when 'history'
        self.history(args)
      when nil
        self.help
        exit 1
      else
        self.run(op, *args)
      end
    rescue => e
      puts "Error: #{e}."
      puts Usage
      exit 1
    end

    def self.help
      puts Help
      puts
      puts Usage
    end

    def self.version
      puts Mpx::VERSION
    end

    def self.history(args)
      history = Loader.new(self.root).history
      puts history.get(*args)
    end

    def self.run(args)
      request = Request.new(args)
      loader = Loader.new(self.root)
      commands = loader.load(request.name).sort
      history = loader.history

      threads = commands.map do |command|
        Thread.new do
          result = command.run(request.args)
          history.write(command.name, *request.args)
          result
        end
      end

      threads.each do |t|
        puts t.value
        puts
      end
    end

    def self.root
      root = ENV[MpxRoot]
      if root
        return root
      end

      home = ENV['HOME']
      if !home
        raise "#{MpxRoot} and $HOME are both not set"
      end

      return File.join(home, DefaultRoot)
    end
  end
end
