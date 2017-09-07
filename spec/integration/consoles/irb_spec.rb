describe "Integration: consoles/irb" do
  let(:app_name) { "rails#{::Rails.version[0..2].tr('.', '')}" }
  let(:cmd_stdout) do
    cmd = Mixlib::ShellOut.new("#{@rails_cmd} console", env: @rails_env, input: 'exit')
    cmd.run_command
    cmd.stdout
  end

  it "displays a colored prompt" do
    expect(cmd_stdout).to include('[32m')
  end

  it "displays the app name" do
    expect(cmd_stdout).to include(app_name)
  end

  it "displays the environment nickname" do
    expect(cmd_stdout).to include('dev')
  end

  context "--no-sandbox" do
    let(:cmd_stdout) do
      cmd = Mixlib::ShellOut.new("#{@rails_cmd} console --no-sandbox", env: @rails_env, input: 'exit')
      cmd.run_command
      cmd.stdout
    end

    it "displays '(writable)'" do
      expect(cmd_stdout).to include('(writable)')
    end
  end

  context "--sandbox" do
    let(:cmd_stdout) do
      cmd = Mixlib::ShellOut.new("#{@rails_cmd} console --sandbox", env: @rails_env, input: 'exit')
      cmd.run_command
      cmd.stdout
    end

    it "displays '(read-only)'" do
      expect(cmd_stdout).to include('(read-only)')
    end
  end
end
