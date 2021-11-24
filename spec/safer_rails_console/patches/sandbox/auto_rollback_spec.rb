# require 'safer_rails_console/patches/sandbox/auto_rollback'

describe "::SaferRailsConsole::Patches::Sandbox::AutoRollback" do
  describe ".handle_and_reraise_exception" do
    let(:mocked_ar_connection) { spy('ar_connection') } # rubocop:disable RSpec/VerifiedDoubles

    # mock ActiveRecord::Base.connection
    before do
      ::SaferRailsConsole::Console.initialize_sandbox
      module ActiveRecord
        module Base
        end
      end
      allow(::ActiveRecord::Base).to receive(:connection).and_return(mocked_ar_connection)
    end

    after do
      Object.send(:remove_const, :ActiveRecord)
    end

    context "when raising a PG::ReadOnlySqlTransaction exception" do
      let(:error) { RuntimeError.new('Beware of the PG::ReadOnlySqlTransaction exception!') }

      it "outputs a message on stdout and forwards the exception" do
        expect do
          ::SaferRailsConsole::Patches::Sandbox::AutoRollback.handle_and_reraise_exception(error)
        end.to raise_exception(error)
           .and output(/An operation could not be completed due to read-only mode./).to_stdout
      end
    end

    context "when raising a classic exception" do
      let(:error) { RuntimeError.new('normal error') }

      it "rollbacks, begins a new transaction and forwards the exception" do
        expect do
          ::SaferRailsConsole::Patches::Sandbox::AutoRollback.handle_and_reraise_exception(error)
        end.to raise_exception(error)

        expect(mocked_ar_connection).to have_received(:rollback_db_transaction).ordered
        expect(mocked_ar_connection).to have_received(:begin_db_transaction).ordered
      end
    end
  end
end
