RSpec.describe SaferRailsConsole::Console do
  context ".initialize_sandbox" do
    specify do
      expect(defined?(SaferRailsConsole::Patches::AutoRollback)).to be_nil

      suppress(Exception) { described_class.initialize_sandbox }

      expect(defined?(SaferRailsConsole::Patches::AutoRollback)).to_not be_nil
    end
  end

  context ".print_warning" do
    let(:expected_output) { "\e[#{SaferRailsConsole.prompt_color}m#{SaferRailsConsole.config.warn_text}\e[0m\n" }

    specify { expect { described_class.print_warning }.to output(expected_output).to_stdout }
  end

  context ".sandbox_prompt_user_input" do
    context "input: 'disable'" do
      before { allow(described_class).to receive(:gets).and_return('disable') }

      specify { expect(described_class.sandbox_prompt_user_input).to be(false) }
    end

    context "input: 'something else'" do
      before { allow(described_class).to receive(:gets).and_return('something else') }

      specify { expect(described_class.sandbox_prompt_user_input).to be(true) }
    end
  end
end