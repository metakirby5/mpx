require 'ansi/code'

module Mpx
  ##
  # Represents the output of a command.
  class Result
    include ANSI::Code

    def initialize(name, out, status)
      @name = name
      @out = out.strip
      @status = status
    end

    def to_s
      out = @out.empty? ? yellow { 'No output.' } : @out
      return [
        cyan { @name },
        cyan { '-' * @name.length },
        out,
        '',
        status_string
      ].join("\n")
    end

    def status_string
      status = @status.exitstatus
      color = status.zero? ? :green : :red
      message = status.zero? ? 'Done!' : "Exited with code #{status}."
      return send(color) { message }
    end
  end
end
