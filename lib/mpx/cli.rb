require 'slop'

require 'mpx/alias'
require 'mpx/command'
require 'mpx/multiplexer'
require 'mpx/history_writer'

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
- `sets`    Aliases to sets of commands. Each file is an alias,
            containing newline-delimited commands to run.
- `history` Newline-delimited history of each command/alias, with timestamp.

The first argument is mandatory, and should be one of:

`history`

  Taking each subsequent argument as a command or alias, the history of each
  will be displayed in chronological order.

  If no arguments are provided, the history of all commands and aliases 
  will be displayed.

A directive in the form of `<COMMAND/ALIAS>:<SUBCOMMAND>` or `:<SUBCOMMAND>`

  In the first form, `<COMMAND/ALIAS>` will be taken as the command or alias
  to run with. If names clash, aliases will take precedence over commands.
  For a given alias, the program will run all commands in the alias file.

  In the second form, the program will run with all commands.

  In both forms, `<SUBCOMMAND>` will be passed as the first argument
  to each command. All arguments after the directive will be passed directly.

  If multiple commands run, they shall run in parallel,
  and outputs will be displayed upon completion.
EOF

  MpxRoot = 'MPX_ROOT'
  DefaultRoot = '~/.local/mpx'
  BinFolder = 'bin'
  SpacesFolder = 'spaces'
  SetsFolder = 'sets'
  HistoryFolder = 'history'

  class Cli
    def self.start()
      begin
        parser = Slop::Parser.new self.opts
        result = parser.parse ARGV
        cmd, args = self
          .parse_args(result.args)
          .values_at(:cmd, :args)
      rescue => e
        puts "Error: #{e}"
        puts
        puts self.opts
        exit 1
      else
        root = ENV.fetch(MpxRoot, DefaultRoot)

        puts "root: #{root}"
        puts "cmd: #{cmd}"
        puts "args: #{args}"

        # TODO: fetch subcommands
        # TODO: multiplex
        # TODO: log to history
      end
    end

    def self.opts
      o = Slop::Options.new

      o.banner = 'Usage: [options] [directive] [args...]'

      o.on '-h', '--help', 'show usage' do
        puts Usage
        puts
        puts o
        exit
      end

      o.on '-v', '--version', 'print the version' do
        puts Mpx::VERSION
        exit
      end

      o
    end

    ##
    # Extracts `<SUBCOMMAND/ALIAS>:<ARG> <ARGS>` into {cmd, args}.
    def self.parse_args(args)
      directive, *rest = args
      if !directive&.include? ':'
        raise ArgumentError.new 'missing directive'
      end

      cmd, first_arg = directive.split ':', 2
      if first_arg.empty?
        raise ArgumentError.new 'missing first arg'
      end

      {cmd: cmd.empty? ? nil : cmd, args: [first_arg, *rest]}
    end
  end
end
