require "test_helper"
require "mpx/cli"

class CliTest < Minitest::Test
  [
    {
      name: 'single_command',
      input: %w(py:deps),
      cmd: 'py',
      args: %w(deps)
    },
    {
      name: 'single_command_with_args',
      input: %w(py:install zenbu),
      cmd: 'py',
      args: %w(install zenbu)
    },
    {
      name: 'no_command',
      input: %w(:deps),
      cmd: nil,
      args: %w(deps)
    },
    {
      name: 'no_command_with_args',
      input: %w(:install zenbu),
      cmd: nil,
      args: %w(install zenbu)
    },
    {
      name: 'just_two_colons',
      input: %w(::),
      cmd: nil,
      args: %w(:)
    },
    {
      name: 'colons_1',
      input: %w(a:b:c :d:),
      cmd: 'a',
      args: %w(b:c :d:)
    },
    {
      name: 'colons_2',
      input: %w(::a b:),
      cmd: nil,
      args: %w(:a b:)
    },
    {
      name: 'colons_3',
      input: %w(a:: b:),
      cmd: 'a',
      args: %w(: b:)
    },
  ].each do |c|
    define_method("test_parses_#{c[:name]}") do
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

  [
    {
      name: 'no_first_arg',
      input: %w(py:)
    },
    {
      name: 'no_first_arg_but_later_args',
      input: %w(py: install)
    },
    {
      name: 'no_directive',
      input: %w(install)
    },
    {
      name: 'just_colon',
      input: %w(:),
    },
  ].each do |c|
    define_method("test_argument_error_#{c[:name]}") do
      assert_raises(ArgumentError) do
        Mpx::Cli.parse_args(c[:input])
      end
    end
  end
end
