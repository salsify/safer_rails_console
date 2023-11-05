# frozen_string_literal: true

describe "Integration: patches/sandbox" do
  context "auto_rollback" do
    it "automatically executes rollback and begins a new transaction after executing a invalid SQL statement" do
      run_console_commands('Model.create!', 'Model.where(invalid: :statement)', 'Model.create!')

      # Run a new console session to ensure the database changes were not saved
      result = run_console_commands('puts "Model Count = #{Model.count}"') # rubocop:disable Lint/InterpolationCheck
      expect(result.stdout).to include('Model Count = 0')
    end
  end

  context "read_only" do
    it "enforces a read_only transaction" do
      # Run a console session that makes some database changes
      run_console_commands('Model.create!', 'Model.create!')

      # Run a new console session to ensure the database changes were not saved
      result = run_console_commands('puts "Model Count = #{Model.count}"') # rubocop:disable Lint/InterpolationCheck
      expect(result.stdout).to include('Model Count = 0')
    end

    it "lets the user know that an operation could not be completed" do
      result = run_console_commands('Model.create!')
      expect(result.stdout).to include('An operation could not be completed due to read-only mode.')
    end
  end

  context "redis readonly" do
    it "enforces readonly commands" do
      # Run a console session that makes some redis changes
      run_console_commands('Redis.new.set("test", "value")')

      # Run a new console session to ensure the redis changes were not saved
      result = run_console_commands('puts "Redis.get(\"test\").nil? = #{Redis.new.get(\'test\').nil?}"') # rubocop:disable Lint/InterpolationCheck Layout/LineLength
      expect(result.stdout).to include('Redis.get("test").nil? = true')
    end

    it "lets the user know that an operation could not be completed" do
      result = run_console_commands('Redis.new.set("test", "value")')
      expect(result.stdout).to include('An operation could not be completed due to read-only mode.')
    end
  end

  context "redis-client readonly" do
    it "enforces readonly commands" do
      # Run a console session that makes some redis changes
      run_console_commands('RedisClient.new.call("SET", "test", "value")')

      # Run a new console session to ensure the redis changes were not saved
      result = run_console_commands(
        'puts "RedisClient.new.call(\"GET\", \"test\").nil? = ' \
        '#{RedisClient.new.call(\'GET\', \'test\').nil?}"' # rubocop:disable Lint/InterpolationCheck
      )
      expect(result.stdout).to include('RedisClient.new.call("GET", "test").nil? = true')
    end

    it "lets the user know that an operation could not be completed" do
      result = run_console_commands('RedisClient.new.call("SET", "test", "value")')
      expect(result.stdout).to include('An operation could not be completed due to read-only mode.')
    end
  end

  def run_console_commands(*commands)
    commands += ['exit']
    run_console('--sandbox', input: commands.join("\n"))
  end
end
