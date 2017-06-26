describe SaferRailsConsole::Console do
  context ".initialize_sandbox" do
    it "loads sandbox patches" do
      expect(defined?(SaferRailsConsole::Patches::Sandbox)).to be_nil

      suppress(Exception) { described_class.initialize_sandbox }

      expect(defined?(SaferRailsConsole::Patches::Sandbox)).not_to be_nil
    end
  end

  context ".print_warning" do
    let(:expected_output) { "\e[#{SaferRailsConsole.prompt_color}m#{SaferRailsConsole.config.warn_text}\e[0m\n" }

    it "outputs the warning text in the correct color" do
      expect { described_class.print_warning }.to output(expected_output).to_stdout
    end
  end

  context ".sandbox_prompt_user_input" do
    context "input: 'disable'" do
      before { allow(described_class).to receive(:gets).and_return('disable') }

      it "disables the sandbox" do
        expect(described_class.sandbox_prompt_user_input).to eq(false)
      end
    end

    context "input: 'something else'" do
      before { allow(described_class).to receive(:gets).and_return('something else') }

      it "enables the sandbox" do
        expect(described_class.sandbox_prompt_user_input).to eq(true)
      end
    end
  end
end
