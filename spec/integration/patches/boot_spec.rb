RSpec.describe "Integration: patches/boot" do
  context "sandbox_flag" do
    let(:cmd_stdout) do
      cmd = Mixlib::ShellOut.new("#{@rails_cmd} console --help")
      cmd.run_command
      cmd.stdout
    end

    it "adds a --no-sandbox flag to 'rails console'" do
      if SaferRailsConsole::RailsVersion.five_one?
        expect(cmd_stdout).to include('--no-sandbox')
      else
        expect(cmd_stdout).to include('--[no-]sandbox')
      end
    end

    context "--no-sandbox" do
      let(:cmd_stdout) do
        cmd = Mixlib::ShellOut.new("#{@rails_cmd} console --no-sandbox", env: @rails_env.merge(RAILS_ENV: 'production'), input: 'exit')
        cmd.run_command
        cmd.stdout
      end

      it "explicitly disables the sandbox if it would be enabled automatically" do
        expect(cmd_stdout).not_to include('Any modifications you make will be rolled back on exit')
      end
    end

    context "--sandbox" do
      let(:cmd_stdout) do
        cmd = Mixlib::ShellOut.new("#{@rails_cmd} console --sandbox", env: @rails_env.merge(RAILS_ENV: 'development'), input: 'exit')
        cmd.run_command
        cmd.stdout
      end

      it "explicitly enables the sandbox if it is not enabled automatically" do
        expect(cmd_stdout).to include('Any modifications you make will be rolled back on exit')
      end
    end
  end
end
