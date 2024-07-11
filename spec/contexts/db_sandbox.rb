# frozen_string_literal: true

shared_context "db sandbox context" do
  let(:adapter) {}

  shared_examples_for "auto_rollback" do
    it "automatically executes rollback and begins a new transaction after executing a invalid SQL statement" do
      run_console_commands('Model.create!', 'Model.where(invalid: :statement)', 'Model.create!')

      # Run a new console session to ensure the database changes were not saved
      result = run_console_commands("puts \"Model Count = \#{Model.count}\"")
      expect(result.stdout).to include('Model Count = 0')
    end
  end

  shared_examples_for "read_only" do
    it "enforces a read_only transaction" do
      # Run a console session that makes some database changes
      run_console_commands('Model.create!', 'Model.create!')

      # Run a new console session to ensure the database changes were not saved
      result = run_console_commands("puts \"Model Count = \#{Model.count}\"")
      expect(result.stdout).to include('Model Count = 0')
    end

    it "lets the user know that an operation could not be completed" do
      result = run_console_commands('Model.create!')
      expect(result.stdout).to include('An operation could not be completed due to read-only mode.')
    end
  end

  def run_console_commands(*commands)
    commands += ['exit']
    environment = "development#{adapter.nil? ? '' : "-#{adapter}"}"
    run_console('--sandbox', input: commands.join("\n"), rails_env: environment)
  end
end
