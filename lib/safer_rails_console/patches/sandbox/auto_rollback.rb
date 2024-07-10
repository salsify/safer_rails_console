# frozen_string_literal: true

module SaferRailsConsole
  module Patches
    module Sandbox
      module AutoRollback
        def self.on(error, message:)
          if error.message.include?(message)
            puts SaferRailsConsole::Colors.color_text( # rubocop:disable Rails/Output
              'An operation could not be completed due to read-only mode.',
              SaferRailsConsole::Colors::RED
            )
          else
            connection = ::ActiveRecord::Base.connection
            connection.rollback_db_transaction
            connection.begin_db_transaction
          end

          raise error
        end

        module PostgreSQLAdapterPatch
          def execute_and_clear(...)
            super
          rescue StandardError => e
            SaferRailsConsole::Patches::Sandbox::AutoRollback.on(e, message: 'PG::ReadOnlySqlTransaction')
          end
        end

        module MySQLPatch
          def execute_and_free(...)
            super
          rescue StandardError => e
            SaferRailsConsole::Patches::Sandbox::AutoRollback.on(e, message: 'READ ONLY transaction')
          end
        end

        if defined?(::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
          ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend(PostgreSQLAdapterPatch)
        end

        if defined?(::ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter)
          ::ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter.prepend(MySQLPatch)
        end
      end
    end
  end
end
