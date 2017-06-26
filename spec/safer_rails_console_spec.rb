describe SaferRailsConsole do
  describe "RAILS_ENV=default (development)" do
    it ".environment_name" do
      expect(described_class.environment_name).to eq('dev')
    end

    it ".prompt_color" do
      expect(described_class.prompt_color).to eq(SaferRailsConsole::Colors::GREEN)
    end

    it ".sandbox_environment?" do
      expect(described_class.sandbox_environment?).to eq(false)
    end

    it ".warn_environment?" do
      expect(described_class.warn_environment?).to eq(false)
    end
  end

  describe "RAILS_ENV=production" do
    before do
      allow(::Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
    end

    it ".environment_name" do
      expect(described_class.environment_name).to eq('prod')
    end

    it ".prompt_color" do
      expect(described_class.prompt_color).to eq(SaferRailsConsole::Colors::RED)
    end

    it ".sandbox_environment?" do
      expect(described_class.sandbox_environment?).to eq(true)
    end

    it ".warn_environment?" do
      expect(described_class.warn_environment?).to eq(true)
    end
  end

  describe "::Configuration" do
    it "has defaults" do
      expect(SaferRailsConsole::Configuration.config).to eq(SaferRailsConsole::Configuration::CONFIG_DEFAULTS)
    end

    it "#set" do
      expect(described_class.config.sandbox_prompt).to eq(false)
      described_class.config.set(sandbox_prompt: true)
      expect(described_class.config.sandbox_prompt).to eq(true)
    end
  end
end
