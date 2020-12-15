# frozen_string_literal: true

describe "Integration: patches/railtie" do
  let(:cmd_stdout) do
    result = run_console(input: 'exit')
    result.stdout
  end

  context "sandbox" do
    let(:cmd_stdout) do
      result = run_console(rails_env: rails_env, input: 'exit')
      result.stdout
    end

    context "RAILS_ENV=development" do
      let(:rails_env) { :development }

      it "does not automatically enable sandbox" do
        expect(cmd_stdout).not_to include('Any modifications you make will be rolled back on exit')
      end

      it "does not warn the user of danger" do
        expect(cmd_stdout).not_to include('WARNING')
      end
    end

    context "RAILS_ENV=production" do
      let(:rails_env) { :production }

      it "automatically enables sandbox" do
        expect(cmd_stdout).to include('Any modifications you make will be rolled back on exit')
      end

      it "warns the user of danger" do
        expect(cmd_stdout).to include('WARNING')
      end
    end
  end
end
