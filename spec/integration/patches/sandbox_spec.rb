describe "Integration: patches/sandbox" do
  let(:cmd) do
    cmd = Mixlib::ShellOut.new("#{@rails_cmd} console --sandbox", env: @rails_env, input: console_commands.join("\n"))
    cmd.run_command
    { stdout: cmd.stdout, stderr: cmd.stderr }
  end

  context "auto_rollback" do
    let(:console_commands) { ['Model.first', 'Model.where(invalid: :statement)', 'exit'] }

    it "automatically executes rollback and begins a new transaction after executing a invalid SQL statement" do
      expect(cmd[:stdout]).to include('ActiveRecord::StatementInvalid')

      # Currently, postgres is used for CI and local development is done against SQLite3
      # TODO: Use 'dotenv' to allow developers to specify a database type
      if ENV['CI']
        expect(cmd[:stderr].scan('ROLLBACK').count).to eq(2)
        expect(cmd[:stderr].scan('BEGIN').count).to eq(1)
      else
        expect(cmd[:stderr].scan('rollback transaction').count).to eq(1)
        expect(cmd[:stderr]).not_to include('begin transaction')
      end
    end
  end

  context "read_only" do
    let(:console_commands) { ['Model.create!', 'exit'] }

    it "enforces a read_only transaction and lets the user know that an operation could not be completed" do
      # Currently, postgres is used for CI and local development is done against SQLite3
      # TODO: Use 'dotenv' to allow developers to specify a database type
      if ENV['CI']
        expect(cmd[:stderr]).to include('SET TRANSACTION READ ONLY')
        expect(cmd[:stdout]).to include('ActiveRecord::StatementInvalid')
        expect(cmd[:stdout]).to include('An operation could not be completed due to read-only mode.')
      else
        expect(cmd[:stderr]).not_to include('SET TRANSACTION READ ONLY')
        expect(cmd[:stdout]).not_to include('ActiveRecord::StatementInvalid')
        expect(cmd[:stdout]).not_to include('An operation could not be completed due to read-only mode.')
      end
    end
  end
end
