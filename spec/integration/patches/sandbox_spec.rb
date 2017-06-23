RSpec.describe "Integration: patches/sandbox" do
  let(:cmd) do
    cmd = Mixlib::ShellOut.new("#{@rails_cmd} console --sandbox", env: @rails_env, input: console_commands.join("\n"))
    cmd.run_command
    { stdout: cmd.stdout, stderr: cmd.stderr }
  end

  context "auto_rollback" do
    let(:console_commands) { ['Model.first', 'exit'] }

    it "automatically executes rollback and begins a new transaction after executing a invalid SQL statement" do
      expect(cmd[:stdout]).to include('ActiveRecord::StatementInvalid')
      expect(cmd[:stderr].scan('rollback transaction').count).to eq(2)
      expect(cmd[:stderr].scan('begin transaction').count).to eq(1)
    end
  end
end
