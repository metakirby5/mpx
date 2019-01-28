require 'slop'

Usage = <<-EOF
A command multiplexer.

The root folder MPX_ROOT is an environment variable
which defaults to `~/.local/mpx`.

The following subfolders are used:
- `bin`     Where subcommands are stored.
- `spaces`  Namespaces for each subcommand.
            Each subcommand receives a subfolder with its name in `spaces`.
            The working directory will be changed to this subfolder before
            subcommand execution.
- `sets`    Aliases to sets of subcommands. Each file is an alias,
            containing newline-delimited subcommands to run.
- `history` Newline-delimited history of each subcommand.

The first argument is mandatory, and should be a directive in the form of
`<SUBCOMMAND/ALIAS>:<ARG>` or `:<ARG>`, where `<ARG>` is optional.

In the first form, `<SUBCOMMAND/ALIAS>` will be taken as the subcommand or
alias to run with.

In the second form, the program will run with all subcommands.

In both forms, `<ARG>` will be passed as the first argument if present.
All arguments after the directive will be passed directly.

If multiple subcommands run, they shall run in parallel,
and outputs will be displayed upon completion.
EOF

module Mpx
  class Cli
    def self.start()
      begin
        parser = Slop::Parser.new self.opts
        result = parser.parse ARGV
        sub, args = self
          .parse_args(result.args)
          .values_at(:sub, :args)
      rescue => e
        puts "Error: #{e}"
        puts
        puts self.opts
        exit 1
      else
        puts "sub: #{sub}"
        puts "args: #{args}"
        # TODO: multiplex
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
    # Extracts `<SUBCOMMAND/ALIAS>:<ARG> <ARGS>` into {sub, args}.
    def self.parse_args(args)
      directive, *rest = args

      if !directive&.include? ':'
        raise ArgumentError.new 'missing directive'
      end

      sub, first_arg = directive.split ':', 2
      return {sub: sub, args: [*first_arg, *rest]}
    end
  end
end
