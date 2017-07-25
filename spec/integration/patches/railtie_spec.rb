describe "Integration: patches/railtie" do
  let(:cmd_stdout) do
    cmd = Mixlib::ShellOut.new("#{@rails_cmd} console", env: @rails_env, input: 'exit')
    cmd.run_command
    cmd.stdout
  end

  context "sandbox" do
    let(:console_commands) { ['exit'] }
    let(:cmd_stdout) do
      cmd = Mixlib::ShellOut.new("#{@rails_cmd} console", env: @rails_env.merge(RAILS_ENV: specified_env), input: console_commands.join("\n"))
      cmd.run_command
      cmd.stdout
    end

    context "RAILS_ENV=development" do
      let(:specified_env) { 'development' }

      it "does not automatically enable sandbox" do
        expect(cmd_stdout).not_to include('Any modifications you make will be rolled back on exit')
      end

      it "does not warn the user of danger" do
        expect(cmd_stdout).not_to include('WARNING')
      end
    end

    context "RAILS_ENV=production" do
      let(:specified_env) { 'production' }

      it "automatically enables sandbox" do
        expect(cmd_stdout).to include('Any modifications you make will be rolled back on exit')
      end

      it "warns the user of danger" do
        expect(cmd_stdout).to include('WARNING')
      end
    end
  end
end
