# frozen_string_literal: true

include SaferRailsConsole::Colors

app_name = if SaferRailsConsole::RailsVersion.six_or_above?
             ::Rails.application.class.module_parent.to_s.underscore.dasherize
           else
             ::Rails.application.class.parent.to_s.underscore.dasherize
           end
env_name = SaferRailsConsole.environment_name
status = ::Rails.application.sandbox ? 'read-only' : 'writable'
color = SaferRailsConsole.prompt_color

prompt = "#{app_name}(#{env_name})(#{status}):%03n:%i"

IRB.conf[:PROMPT][:RAILS_ENV] = {
  PROMPT_I: color_text("#{prompt}> ", color),
  PROMPT_N: color_text("#{prompt}> ", color),
  PROMPT_S: color_text("#{prompt}%l ", color),
  PROMPT_C: color_text("#{prompt}* ", color),
  RETURN: "#{color_text('=> ', color)}%s\n"
}

IRB.conf[:PROMPT_MODE] = :RAILS_ENV
