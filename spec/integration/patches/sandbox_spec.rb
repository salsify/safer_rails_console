describe "Integration: patches/sandbox" do
  context "auto_rollback" do
    it "automatically executes rollback and begins a new transaction after executing a invalid SQL statement" do
      run_console('Model.create!', 'Model.where(invalid: :statement)', 'Model.create!')

      # Run a new console session to ensure the database changes were not saved
      results = run_console('puts "Model Count = #{Model.count}"')
      expect(results[:stdout]).to include("Model Count = 0")
    end
  end

  context "read_only" do
    it "enforces a read_only transaction" do
      # Run a console session that makes some database changes
      run_console('Model.create!', 'Model.create!')

      # Run a new console session to ensure the database changes were not saved
      results = run_console('puts "Model Count = #{Model.count}"')
      expect(results[:stdout]).to include("Model Count = 0")
    end

    it "lets the user know that an operation could not be completed" do
      results = run_console('Model.create!')
      # Currently, postgres is used for CI and local development is done against SQLite3
      # TODO: We should get these warnings for all types databases not just postgres
      if ENV['CI']
        expect(results[:stdout]).to include('An operation could not be completed due to read-only mode.')
      else
        expect(results[:stdout]).not_to include('An operation could not be completed due to read-only mode.')
      end
    end
  end

  def run_console(*commands)
    commands += ['exit']
    cmd = Mixlib::ShellOut.new("#{@rails_cmd} console --sandbox", env: @rails_env, input: commands.join("\n"))
    cmd.run_command
    { stdout: cmd.stdout, stderr: cmd.stderr }
  end
end
