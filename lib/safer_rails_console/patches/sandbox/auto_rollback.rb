module SaferRailsConsole
  module Patches
    module Sandbox
      module AutoRollback
        module ActiveRecord
          module ConnectionAdapters
            module AbstractAdapter
              def log(sql, name = 'SQL', binds = [], statement_name = nil)
                super(sql, name, binds, statement_name) { yield }
              rescue => e
                connection = ::ActiveRecord::Base.connection
                connection.rollback_db_transaction
                connection.begin_db_transaction
                raise e
              end
            end
          end
        end
      end
    end
  end
end

::ActiveRecord::ConnectionAdapters::AbstractAdapter.prepend(SaferRailsConsole::Patches::Sandbox::AutoRollback::ActiveRecord::ConnectionAdapters::AbstractAdapter)
