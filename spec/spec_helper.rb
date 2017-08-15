require 'bundler/setup'
require 'mixlib/shellout'
require 'safer_rails_console'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  rails_root = File.join(RSpec::Core::RubyProject.root, 'spec', 'internal', "rails_#{::Rails.version[0..2].tr('.', '_')}")

  config.before :suite do
    system("cd #{rails_root} && rake db:drop && rake db:setup")
  end

  config.before :all do
    @rails_root = rails_root
    @rails_cmd = File.join(@rails_root, 'bin', 'rails')
    @rails_env = { BUNDLE_GEMFILE: File.join(@rails_root, 'Gemfile') }
  end

  config.before :each do
    allow(::Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development'))
  end
end
