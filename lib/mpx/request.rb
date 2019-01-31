module Mpx
  ##
  # Extracts `<SUBCOMMAND/ALIAS>:<ARG> <ARGS>`.
  class Request
    def initialize(args)
      directive, *rest = args
      if !directive&.include? ':'
        raise 'missing directive'
      end

      cmd, first_arg = directive.split ':', 2
      if first_arg.empty?
        raise 'missing subcommand'
      end

      @name = cmd.empty? ? nil : cmd
      @args = [first_arg, *rest]
    end

    def name
      return @name
    end

    def args
      return @args
    end
  end
end
