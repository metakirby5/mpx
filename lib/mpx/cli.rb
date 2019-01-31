require 'slop'

require 'mpx/request'
require 'mpx/loader'

module Mpx

  Usage = <<-EOF
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

The first argument is mandatory, and should be one of:

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
    MpxRoot = 'MPX_ROOT'
    DefaultRoot = File.join('.local', 'mpx')

    def self.start()
      begin
        parser = Slop::Parser.new(self.opts)
        result = parser.parse(ARGV)
        # TODO: handle history

        request = Request.new(result.args)
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
      rescue => e
        puts "Error: #{e}."
        puts
        puts self.opts
        exit 1
      else
      end
    end

    def self.opts
      o = Slop::Options.new

      o.banner = 'Usage: [options] [directive] [args...]'

      o.on('-h', '--help', 'show usage') do
        puts Usage
        puts
        puts o
        exit
      end

      o.on('-v', '--version', 'print the version') do
        puts Mpx::VERSION
        exit
      end

      return o
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
