# SaferRailsConsole

This gem makes console sessions less dangerous in specified environments by warning, color-coding, auto-sandboxing, and disabling external connections, job queueing, etc.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'safer_rails_console'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install safer_rails_console

## Usage

This gem is autoloaded via Railties.  The following defaults can be configured from `environments` or `application.rb`:
```ruby
# Set what console is used. Currently, only 'irb' is supported. 'pry' and other consoles are to-be added.
config.safer_rails_console.console = 'irb'
 
# Mapping environments to shortened names. `false` to disable.
config.safer_rails_console.env_names = {
                                         'development' => 'dev',
                                         'staging' => 'staging',
                                         'production' => 'prod'
                                       }
                                       
# Mapping environments to console prompt colors. See colors.rb for colors. `false` to disable.
config.safer_rails_console.prompt_colors = {
                                             'development' => GREEN,
                                             'staging' => YELLOW,
                                             'production' => RED
                                           }
                                           
# Set environments which should default to sandbox. `false` to disable.
config.safer_rails_console.sandbox = ['production']
 
# Set the keyword users need to enter to disable sandbox mode upon console entry for the specified environments.
config.safer_rails_console.sandbox_disable_keyword = 'production'
 
# Set environments that should have a warning. `false` to disable.
config.safer_rails_console.warn = ['production']
 
# Set warning message that should appear in the specified environments.
config.safer_rails_console.warn_text = "WARNING: YOU ARE USING RAILS CONSOLE UNSANDBOXED!\n" \
                                       'Changing data can cause serious data loss. ' \
                                       'Make sure you know what you\'re doing.'
```

The quickest way to demo this gem is to add 'development' to `config.safer_rails_console.sandbox` and `config.safer_rails_console.warn`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/safer_rails_console. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
