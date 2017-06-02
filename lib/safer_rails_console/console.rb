module SaferRailsConsole
  module Console
    include SaferRailsConsole::Colors

    def initialize_sandbox
      enable_auto_rollback
    end

    def print_warning
      env = Rails.env.downcase
      color = config.prompt_colors ? config.prompt_colors.fetch(env, NONE) : NONE

      if config.warn && config.warn.include?(env)
        puts color_text(config.warn_text, color) if config.warn_text # rubocop:disable Rails/Output
      end
    end

    def sandbox_prompt
      puts "Defaulting the console into sandbox mode.\nType '#{config.sandbox_disable_keyword}' to disable. Anything else will begin a sandboxed session:" # rubocop:disable Rails/Output
      gets.strip != config.sandbox_disable_keyword
    end

    private

    def enable_auto_rollback
      if defined?(ActiveRecord::ConnectionAdapters::AbstractAdapter)
        ActiveRecord::ConnectionAdapters::AbstractAdapter.class_eval do
          def log_with_console(sql, name = 'SQL', binds = [], statement_name = nil)
            log_without_console(sql, name, binds, statement_name) { yield }
          rescue => e
            connection = ActiveRecord::Base.connection
            connection.rollback_db_transaction
            connection.begin_db_transaction
            raise e
          end
          alias_method_chain :log, :console
        end
      end
    end

    def config
      @config ||= SaferRailsConsole.configuration
    end
  end
end
