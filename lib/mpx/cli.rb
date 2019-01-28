require 'slop'

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
- `history` Newline-delimited history of each command.

The first argument is mandatory, and should be a directive in the form of
`<COMMAND/ALIAS>:<ARG>` or `:<ARG>`.

In the first form, `<COMMAND/ALIAS>` will be taken as the command or alias
to run with.

In the second form, the program will run with all commands.

In both forms, `<ARG>` will be passed as the first argument.
All arguments after the directive will be passed directly.

If multiple commands run, they shall run in parallel,
and outputs will be displayed upon completion.
EOF

MpxRoot = 'MPX_ROOT'
DefaultRoot = '~/.local/mpx'

module Mpx
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
