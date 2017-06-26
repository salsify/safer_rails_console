::Rails::Application.class_eval do
  console do
    gem = Gem::Specification.find_by_name('safer_rails_console') # rubocop:disable Rails/DynamicFindBy
    gem_root = gem.gem_dir
    ARGV.push '-r', File.join(gem_root, 'lib', 'safer_rails_console', 'consoles', "#{SaferRailsConsole.config.console}.rb")
  end
end
