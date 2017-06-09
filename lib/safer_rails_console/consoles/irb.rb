include SaferRailsConsole::Colors

config = SaferRailsConsole.config
env = ::Rails.env.downcase

app_name = ::Rails.application.class.parent.to_s.downcase
env_name = config.environment_names ? config.environment_names.fetch(env, 'unknown') : env
status = ::Rails.application.sandbox ? 'sandboxed' : 'unsandboxed'
color = config.environment_prompt_colors ? config.environment_prompt_colors.fetch(env, NONE) : NONE

prompt = "#{app_name}(#{env_name})(#{status}):%03n:%i"

IRB.conf[:PROMPT][:RAILS_ENV] = {
  PROMPT_I: color_text("#{prompt}> ", color),
  PROMPT_N: color_text("#{prompt}> ", color),
  PROMPT_S: color_text("#{prompt}%l ", color),
  PROMPT_C: color_text("#{prompt}* ", color),
  RETURN: color_text('=> ', color).concat("%s\n")
}

IRB.conf[:PROMPT_MODE] = :RAILS_ENV

