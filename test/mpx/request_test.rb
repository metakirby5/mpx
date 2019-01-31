require 'config'
require 'mpx/request'

describe Mpx::Request do
  describe 'ValidInput' do
    def self.it_parses(test_case)
      input, exp_name, exp_args = test_case
        .values_at(:input, :name, :args)

      it "parses `#{input.join(' ')}`" do
        request = Mpx::Request.new(input)

        if exp_name.nil?
          assert_nil(request.name)
        else
          assert_equal(exp_name, request.name)
        end

        assert_equal(exp_args, request.args)
      end
    end

    [
      {
        input: %w(py:deps),
        name: 'py',
        args: %w(deps)
      },
      {
        input: %w(py:install zenbu),
        name: 'py',
        args: %w(install zenbu)
      },
      {
        input: %w(:deps),
        name: nil,
        args: %w(deps)
      },
      {
        input: %w(:install zenbu),
        name: nil,
        args: %w(install zenbu)
      },
      {
        input: %w(::),
        name: nil,
        args: %w(:)
      },
      {
        input: %w(a:b:c :d:),
        name: 'a',
        args: %w(b:c :d:)
      },
      {
        input: %w(::a b:),
        name: nil,
        args: %w(:a b:)
      },
      {
        input: %w(a:: b:),
        name: 'a',
        args: %w(: b:)
      },
    ].each(&method(:it_parses))
  end

  describe 'InvalidInput' do
    def self.it_raises(input)
      it "raises for `#{input.join(' ')}`" do
        assert_raises do
          Mpx::Request.new(input)
        end
      end
    end

    [
      %w(py:),
      %w(py: install),
      %w(py install),
      %w(install),
      %w(:),
    ].each(&method(:it_raises))
  end
end
