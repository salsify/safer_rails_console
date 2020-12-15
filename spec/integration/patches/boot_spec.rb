# frozen_string_literal: true

describe "Integration: patches/boot" do
  context "sandbox_flag" do
    let(:cmd_stdout) do
      result = run_console('--help')
      result.stdout
    end

    it "adds relevant flags to 'rails console'" do
      if SaferRailsConsole::RailsVersion.five_one_or_above?
        expect(cmd_stdout).to include('--no-sandbox')
      else
        expect(cmd_stdout).to include('--[no-]sandbox')
      end

      expect(cmd_stdout).to include('--read-only')
      expect(cmd_stdout).to include('--writable')
    end

    context "--no-sandbox" do
      let(:cmd_stdout) do
        result = run_console('--no-sandbox', rails_env: :production, input: 'exit')
        result.stdout
      end

      it "explicitly disables the sandbox if it would be enabled automatically" do
        expect(cmd_stdout).not_to include('Any modifications you make will be rolled back on exit')
      end
    end

    context "--sandbox" do
      let(:cmd_stdout) do
        result = run_console('--sandbox', rails_env: :development, input: 'exit')
        result.stdout
      end

      it "explicitly enables the sandbox if it is not enabled automatically" do
        expect(cmd_stdout).to include('Any modifications you make will be rolled back on exit')
      end
    end

    context "--read-only" do
      let(:cmd_stdout) do
        result = run_console('--read-only', rails_env: :development, input: 'exit')
        result.stdout
      end

      it "explicitly enables the sandbox if it is not enabled automatically" do
        expect(cmd_stdout).to include('Any modifications you make will be rolled back on exit')
      end
    end

    context "--writable" do
      let(:cmd_stdout) do
        result = run_console('--writable', rails_env: :production, input: 'exit')
        result.stdout
      end

      it "explicitly disables the sandbox if it would be enabled automatically" do
        expect(cmd_stdout).not_to include('Any modifications you make will be rolled back on exit')
      end
    end
  end
end
