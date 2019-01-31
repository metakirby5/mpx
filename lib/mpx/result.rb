require 'ansi/code'

module Mpx
  ##
  # Represents the output of a command.
  class Result
    include ANSI::Code

    def initialize(name, out, status)
      @name = name
      @out = out
      @status = status
    end

    def to_s
      return [cyan { @name }, @out.strip, status_string].join("\n")
    end

    def status_string
      color = @status.exitstatus.zero? ? :green : :red
      return send(color) { @status }
    end
  end
end
