module SaferRailsConsole
  module Patches
    module Sandbox
      module AutoRollback
        module ActiveRecord
          module ConnectionAdapters
            module AbstractAdapter4
              def log(sql, name = 'SQL', binds = [], statement_name = nil)
                super
              rescue => e
                connection = ::ActiveRecord::Base.connection
                connection.rollback_db_transaction
                connection.begin_db_transaction
                raise e
              end
            end

            module AbstractAdapter5
              def log(sql, name = 'SQL', binds = [], type_casted_binds = [], statement_name = nil)
                super
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

if SaferRailsConsole::RailsVersion.four_one? || SaferRailsConsole::RailsVersion.four_two?
  ::ActiveRecord::ConnectionAdapters::AbstractAdapter.prepend(SaferRailsConsole::Patches::Sandbox::AutoRollback::ActiveRecord::ConnectionAdapters::AbstractAdapter4)
else
  ::ActiveRecord::ConnectionAdapters::AbstractAdapter.prepend(SaferRailsConsole::Patches::Sandbox::AutoRollback::ActiveRecord::ConnectionAdapters::AbstractAdapter5)
end
