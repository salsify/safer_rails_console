# SaferRailsConsole

[![Build Status](https://circleci.com/gh/salsify/safer_rails_console.svg?style=svg)](https://circleci.com/gh/salsify/safer_rails_console)
[![Gem Version](https://badge.fury.io/rb/safer_rails_console.svg)](https://badge.fury.io/rb/safer_rails_console)

This gem makes Rails console sessions less dangerous in specified environments by warning, color-coding, and auto-sandboxing PostgreSQL and MySQL connections. In the future we'd like to extend this to make other external connections read-only too (e.g. disable job queueing, non-GET HTTP requests, etc.)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'safer_rails_console'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install safer_rails_console

Add the following line to the end of 'config/boot.rb' in your Rails application.
```ruby
require 'safer_rails_console/patches/boot'
```

## Usage

The quickest way to demo this gem is to run `bundle exec rails console --sandbox`.

Several ways to explicitly enable or disable the sandbox are added to Rails console as flags with the last install step.  The order of precedence is `-s`, `-r`, then `-w` if multiple sandbox related flags are specified.
```ruby
bundle exec rails console --help  

Usage: rails console [environment] [options]
    -s, --[no-]sandbox               Explicitly enable/disable sandbox mode.
    -w, --writable                   Alias for --no-sandbox.
    -r, --read-only                  Alias for --sandbox.
    -e, --environment=name           Specifies the environment to run this console under (test/development/production).
                                     Default: development
        --debugger                   Enable the debugger.
```

This gem is autoloaded via Railties.  The following defaults can be configured from 'environments' or 'application.rb':
```ruby
# Set what console is used. Currently, only 'irb' is supported. 'pry' and other consoles are to be added.
config.safer_rails_console.console = 'irb'  

# Mapping environments to shortened names. `false` to disable.
config.safer_rails_console.environment_names = {
                                                 'development' => 'dev',
                                                 'staging' => 'staging',
                                                 'production' => 'prod'
                                               }  
# Mapping environments to console prompt colors. See colors.rb for colors. `false` to disable.
config.safer_rails_console.environment_prompt_colors = {
                                                         'development' => SaferRailsConsole::Colors::GREEN,
                                                         'staging' => SaferRailsConsole::Colors::YELLOW,
                                                         'production' => SaferRailsConsole::Colors::RED
                                                       }  

# Set environments which should default to sandbox. `false` to disable.
config.safer_rails_console.sandbox_environments = %w{production}  

# Set 'true' to have a prompt that asks the user if sandbox should be enabled/disabled if it was not explicitly specified (via. --[no-]sandbox)
config.safer_rails_console.sandbox_prompt = false  

# Set environments that should have a warning. `false` to disable.
config.safer_rails_console.warn_environments = %w{production}  

# Set warning message that should appear in the specified environments.
config.safer_rails_console.warn_text = "WARNING: YOU ARE USING RAILS CONSOLE IN PRODUCTION!\n" \
                                       'Changing data can cause serious data loss. ' \
                                       'Make sure you know what you\'re doing.'
```

configuration settings can also be overridden using ENV variables. The following ENV vars can be used:
```
# Set the color prompt to a new color. See colors.rb for a listing of supported colors.
SAFER_RAILS_CONSOLE_PROMPT_COLOR=red/yellow/green

# Set the short name for the rails console prompt
SAFER_RAILS_CONSOLE_ENVIRONMENT_NAME=short-name

# Set the warning text to be displayed when warning for the environments rails consoled is enabled
SAFER_RAILS_CONSOLE_WARN_TEXT=New warning prompt text

# Enable or disable sandboxing of the rails console
SAFER_RAILS_CONSOLE_SANDBOX_ENVIRONMENT=true/false

# Enable or disable warning prompt of the rails console
SAFER_RAILS_CONSOLE_WARN_ENVIRONMENT=true/false
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `wwtd` to simulate the entire build matrix (ruby version / rails version) or `appraisal` to test against each supported rails version with your active ruby version. Run `rubocop` to check for style. 

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/salsify/safer_rails_console. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
