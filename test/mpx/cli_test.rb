require "minitest/autorun"
require "mpx/cli"

describe Mpx::Cli do
  describe 'when input is valid' do
    [
      {
        case: 'single command',
        input: %w(py:deps),
        cmd: 'py',
        args: %w(deps)
      },
      {
        case: 'single command with args',
        input: %w(py:install zenbu),
        cmd: 'py',
        args: %w(install zenbu)
      },
      {
        case: 'no command',
        input: %w(:deps),
        cmd: nil,
        args: %w(deps)
      },
      {
        case: 'no command with args',
        input: %w(:install zenbu),
        cmd: nil,
        args: %w(install zenbu)
      },
      {
        case: 'just two colons',
        input: %w(::),
        cmd: nil,
        args: %w(:)
      },
      {
        case: 'colons 1',
        input: %w(a:b:c :d:),
        cmd: 'a',
        args: %w(b:c :d:)
      },
      {
        case: 'colons 2',
        input: %w(::a b:),
        cmd: nil,
        args: %w(:a b:)
      },
      {
        case: 'colons 3',
        input: %w(a:: b:),
        cmd: 'a',
        args: %w(: b:)
      },
    ].each do |c|
      it "must parse #{c[:case]}" do
        cmd, args = Mpx::Cli
          .parse_args(c[:input])
          .values_at(:cmd, :args)

        if c[:cmd]
          assert_equal c[:cmd], cmd
        else
          assert_nil c[:cmd]
        end

        assert_equal c[:args], args
      end
    end
  end

  describe 'when input is invalid' do
    [
      {
        case: 'no first arg',
        input: %w(py:)
      },
      {
        case: 'no first arg but later args',
        input: %w(py: install)
      },
      {
        case: 'no directive',
        input: %w(install)
      },
      {
        case: 'just colon',
        input: %w(:),
      },
    ].each do |c|
      it "must raise ArgumentError for #{c[:case]}" do
        assert_raises(ArgumentError) do
          Mpx::Cli.parse_args(c[:input])
        end
      end
    end
  end
end
