require 'ansi/code'

module Mpx
  ##
  # Represents the output of a command.
  class Result
    include ANSI::Code

    def initialize(out, status)
      @out = out
      @status = status
    end

    def to_s
      return [out, status_string].join("\n")
    end

    def out
      return @out
    end

    def status_string
      color = @status.exitstatus.zero? ? :green : :red
      return send(color) { @status }
    end
  end
end
