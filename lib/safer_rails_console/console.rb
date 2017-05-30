module SaferRailsConsole
  module Console
    def initialize_sandbox
      auto_rollback
    end

    def auto_rollback
      if defined?(ActiveRecord::ConnectionAdapters::AbstractAdapter)
        ActiveRecord::ConnectionAdapters::AbstractAdapter.class_eval do
          def log_with_console(sql, name = "SQL", binds = [], statement_name = nil)
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

    def user_input
      config = SaferRailsConsole.configuration

      puts "Defaulting the console into sandbox mode.\n" \
                       "Type '#{config.sandbox_disable_keyword}' to disable. Anything else will begin a sandboxed session:"
      gets.strip != config.sandbox_disable_keyword
    end
  end
end
