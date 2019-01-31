require 'test_helper'
require 'mpx/cli'

describe Mpx::Cli do
  describe 'ValidInput' do
    def self.it_parses(test_case)
      input, exp_cmd, exp_args = test_case
        .values_at(:input, :cmd, :args)

      it "parses `#{input.join ' '}`" do
        cmd, args = Mpx::Cli
          .parse_args(input)
          .values_at(:cmd, :args)

        if exp_cmd.nil?
          assert_nil cmd
        else
          assert_equal exp_cmd, cmd
        end

        assert_equal exp_args, args
      end
    end

    [
      {
        input: %w(py:deps),
        cmd: 'py',
        args: %w(deps)
      },
      {
        input: %w(py:install zenbu),
        cmd: 'py',
        args: %w(install zenbu)
      },
      {
        input: %w(:deps),
        cmd: nil,
        args: %w(deps)
      },
      {
        input: %w(:install zenbu),
        cmd: nil,
        args: %w(install zenbu)
      },
      {
        input: %w(::),
        cmd: nil,
        args: %w(:)
      },
      {
        input: %w(a:b:c :d:),
        cmd: 'a',
        args: %w(b:c :d:)
      },
      {
        input: %w(::a b:),
        cmd: nil,
        args: %w(:a b:)
      },
      {
        input: %w(a:: b:),
        cmd: 'a',
        args: %w(: b:)
      },
    ].each(&method(:it_parses))
  end

  describe 'InvalidInput' do
    def self.it_raises_argument_error(input)
      it "raises ArgumentError for `#{input.join ' '}`" do
        assert_raises(ArgumentError) do
          Mpx::Cli.parse_args(input)
        end
      end
    end

    [
      %w(py:),
      %w(py: install),
      %w(py install),
      %w(install),
      %w(:),
    ].each(&method(:it_raises_argument_error))
  end
end
