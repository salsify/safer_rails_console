include SaferRailsConsole::Colors

config = SaferRailsConsole.configuration

app = ::Rails.application.class.parent.to_s.downcase
env = ::Rails.env.downcase

color = config.prompt_colors ? config.prompt_colors.fetch(env, NONE) : NONE
env_name = config.prompt_colors ? config.env_names.fetch(env, 'unknown env') : env

if config.warn && config.warn.include?(env)
  puts color_text(config.warn_text, color) if config.warn_text
end

IRB.conf[:PROMPT][:RAILS_ENV] = {
  PROMPT_I: color_text("#{app}(#{env_name}):%03n:%i> ", color),
  PROMPT_N: color_text("#{app}(#{env_name}):%03n:%i> ", color),
  PROMPT_S: color_text("#{app}(#{env_name}):%03n:%i%l ", color),
  PROMPT_C: color_text("#{app}(#{env_name}):%03n:%i* ", color),
  RETURN: color_text('=> ', color).concat("%s\n")
}

IRB.conf[:PROMPT_MODE] = :RAILS_ENV
