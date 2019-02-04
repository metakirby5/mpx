# mpx

```
A command multiplexer.

The root folder MPX_ROOT is an environment variable
which defaults to `$XDG_DATA_HOME/mpx`, i.e. `~/.local/share/mpx`.

The following subfolders are used:
- `bin`     Where commands are stored.
- `spaces`  Namespaces for each command.
            Each command receives a subfolder with its name in `spaces`.
            The working directory will be changed to this subfolder before
            command execution.
- `sets`    Aliases to sets of commands. Each file is a set,
            containing newline-delimited commands to run.
- `history` Newline-delimited history of each command/alias, with timestamp.

The first argument is a mandatory operation, and should be one of:

`help`

  Prints this help text.

`version`

  Prints the version.

`history`

  Taking each subsequent argument as a command or set, the history of each
  will be displayed in chronological order.

  If no arguments are provided, the history of all commands and sets
  will be displayed.

A directive in the form of `<COMMAND/SET>:<SUBCOMMAND>` or `:<SUBCOMMAND>`

  In the first form, `<COMMAND/SET>` will be taken as the command or set
  to run with. If names clash, commands will take precedence over sets.
  For a given set, the program will run all commands in the set file.

  In the second form, the program will run with all commands.

  In both forms, `<SUBCOMMAND>` will be passed as the first argument
  to each command. All arguments after the directive will be passed directly.

  If multiple commands run, they shall run in parallel,
  and outputs will be displayed upon completion.
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mpx'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mpx

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/metakirby5/mpx.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
