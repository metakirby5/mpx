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
      status = @status.exitstatus
      color = status.zero? ? :green : :red
      message = status.zero? ? 'Done!' : "Exited with code #{status}."
      return send(color) { message }
    end
  end
end
