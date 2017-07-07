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

  context ".load_config" do
    before { described_class.load_config }

    it "adds console config file to ARGV" do
      expect(ARGV.any? { |arg| arg.include?('irb.rb') }).to be(true)
    end
  end
end
