module SaferRailsConsole
  module Patches
    module Sandbox
      module AutoRollback
        extend SaferRailsConsole::Colors

        def self.rollback_and_begin_new_transaction
          connection = ::ActiveRecord::Base.connection
          connection.rollback_db_transaction
          connection.begin_db_transaction
        end

        def self.handle_and_reraise_exception(e)
          if e.message.include?('PG::ReadOnlySqlTransaction')
            puts color_text('An operation could not be completed due to read-only mode.', Colors::RED) # rubocop:disable Rails/Output
          else
            rollback_and_begin_new_transaction
          end

          raise e
        end

        module ActiveRecord
          module ConnectionAdapters
            module PostgreSQLAdapter42
              def execute_and_clear(sql, name, binds)
                super
              rescue => e
                SaferRailsConsole::Patches::Sandbox::AutoRollback.handle_and_reraise_exception(e)
              end
            end

            module PostgreSQLAdapter5
              def execute_and_clear(sql, name, binds, prepare: false)
                super
              rescue => e
                SaferRailsConsole::Patches::Sandbox::AutoRollback.handle_and_reraise_exception(e)
              end
            end
          end
        end
      end
    end
  end
end

if defined?(::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
  if SaferRailsConsole::RailsVersion.four_two?
    ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend(SaferRailsConsole::Patches::Sandbox::AutoRollback::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter42)
  else
    ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend(SaferRailsConsole::Patches::Sandbox::AutoRollback::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter5)
  end
end
