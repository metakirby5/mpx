require "test_helper"
require "mpx/cli"

class CliTest < Minitest::Test
  [
    {
      name: 'single_subcommand',
      input: %w(py:deps),
      sub: 'py',
      args: %w(deps)
    },
    {
      name: 'single_subcommand_with_args',
      input: %w(py:install zenbu),
      sub: 'py',
      args: %w(install zenbu)
    },
    {
      name: 'no_subcommand',
      input: %w(:deps),
      sub: nil,
      args: %w(deps)
    },
    {
      name: 'no_subcommand_with_args',
      input: %w(:install zenbu),
      sub: nil,
      args: %w(install zenbu)
    },
    {
      name: 'just_two_colons',
      input: %w(::),
      sub: nil,
      args: %w(:)
    },
    {
      name: 'colons_1',
      input: %w(a:b:c :d:),
      sub: 'a',
      args: %w(b:c :d:)
    },
    {
      name: 'colons_2',
      input: %w(::a b:),
      sub: nil,
      args: %w(:a b:)
    },
    {
      name: 'colons_3',
      input: %w(a:: b:),
      sub: 'a',
      args: %w(: b:)
    },
  ].each do |c|
    define_method("test_parses_#{c[:name]}") do
      sub, args = Mpx::Cli
        .parse_args(c[:input])
        .values_at(:sub, :args)

      if c[:sub]
        assert_equal c[:sub], sub
      else
        assert_nil c[:sub]
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
