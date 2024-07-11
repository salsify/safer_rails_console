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

        module PostgreSQLAdapterPatch
          def execute_and_clear(...)
            super
          rescue StandardError => e
            # rubocop:disable Layout/LineLength
            SaferRailsConsole::Patches::Sandbox::AutoRollback.handle_and_reraise_exception(e, 'PG::ReadOnlySqlTransaction')
            # rubocop:enable Layout/LineLength
          end
        end

        if defined?(::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
          ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend(PostgreSQLAdapterPatch)
        end

        module MySQLPatch
          def execute_and_free(...)
            super
          rescue StandardError => e
            SaferRailsConsole::Patches::Sandbox::AutoRollback.handle_and_reraise_exception(e, 'READ ONLY transaction')
          end
        end

        if defined?(::ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter)
          ::ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter.prepend(MySQLPatch)
        end
      end
    end
  end
end
