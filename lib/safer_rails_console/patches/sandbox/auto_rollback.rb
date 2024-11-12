# frozen_string_literal: true

module SaferRailsConsole
  module Patches
    module Sandbox
      module AutoRollback

        def self.rollback_and_begin_new_transaction
          connection = ::ActiveRecord::Base.connection
          connection.rollback_db_transaction
          connection.begin_db_transaction
        end

        def self.handle_and_reraise_exception(error, message = 'PG::ReadOnlySqlTransaction')
          if error.message.include?(message)
            puts SaferRailsConsole::Colors.color_text( # rubocop:disable Rails/Output
              'An operation could not be completed due to read-only mode.',
              SaferRailsConsole::Colors::RED
            )
          else
            rollback_and_begin_new_transaction
          end

          raise error
        end

        # Patch for the PostgreSQL database adapter for Rails 8.0 and above.
        module PostgreSQLAdapteRailsPatch
          def internal_execute(...)
            super
          rescue StandardError => e
            # rubocop:disable Layout/LineLength
            SaferRailsConsole::Patches::Sandbox::AutoRollback.handle_and_reraise_exception(e, 'PG::ReadOnlySqlTransaction')
            # rubocop:enable Layout/LineLength
          end
        end

        # Patch for the PostgreSQL database adapter for Rails 6.x and 7.x.
        module LegacyPostgreSQLAdapteRailsPatch
          def execute_and_clear(...)
            super
          rescue StandardError => e
            # rubocop:disable Layout/LineLength
            SaferRailsConsole::Patches::Sandbox::AutoRollback.handle_and_reraise_exception(e, 'PG::ReadOnlySqlTransaction')
            # rubocop:enable Layout/LineLength
          end
        end

        if defined?(::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
          if SaferRailsConsole::RailsVersion.eight_or_above?
            ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend(PostgreSQLAdapteRailsPatch)
          elsif SaferRailsConsole::RailsVersion.six_or_above?
            ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend(LegacyPostgreSQLAdapteRailsPatch)
          end
        end

        # Patch for the MySQL database adapter for Rails 8.0 and above.
        module MySQLAdapterRailsPatch
          def internal_execute(...)
            super
          rescue StandardError => e
            SaferRailsConsole::Patches::Sandbox::AutoRollback.handle_and_reraise_exception(e, 'READ ONLY transaction')
          end
        end

        # Patch for the MySQL database adapter for Rails 6.x and 7.x.
        module LegacyMySQLAdapterRails67Patch
          def execute_and_free(...)
            super
          rescue StandardError => e
            SaferRailsConsole::Patches::Sandbox::AutoRollback.handle_and_reraise_exception(e, 'READ ONLY transaction')
          end
        end

        if defined?(::ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter)
          if SaferRailsConsole::RailsVersion.eight_or_above?
            ::ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter.prepend(MySQLAdapterRailsPatch)
          elsif SaferRailsConsole::RailsVersion.six_or_above?
            ::ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter.prepend(LegacyMySQLAdapterRails67Patch)
          end
        end
      end
    end
  end
end
