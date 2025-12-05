# frozen_string_literal: true

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
      SaferRailsConsole::Configuration::CONFIG_DEFAULTS.each do |key, value|
        expect(described_class.config.send(key)).to eq(value)
      end
    end

    it "#set" do
      expect(described_class.config.sandbox_prompt).to eq(false)
      described_class.config.set(sandbox_prompt: true)
      expect(described_class.config.sandbox_prompt).to eq(true)
    end

    it "#set with ENV vars" do
      with_modified_env SAFER_RAILS_CONSOLE_WARN_TEXT: 'warn-text',
                        SAFER_RAILS_CONSOLE_ENVIRONMENT_NAME: 'short-name',
                        SAFER_RAILS_CONSOLE_WARN_ENVIRONMENT: 'true',
                        SAFER_RAILS_CONSOLE_SANDBOX_ENVIRONMENT: 'true',
                        SAFER_RAILS_CONSOLE_PROMPT_COLOR: 'red' do
        expect(described_class.warn_text).to eq('warn-text')
        expect(described_class.environment_name).to eq('short-name')
        expect(described_class.warn_environment?).to eq(true)
        expect(described_class.sandbox_environment?).to eq(true)
        expect(described_class.prompt_color).to eq(31)
      end
    end

    it "#set with false ENV vars" do
      with_modified_env SAFER_RAILS_CONSOLE_WARN_ENVIRONMENT: 'false',
                        SAFER_RAILS_CONSOLE_SANDBOX_ENVIRONMENT: 'false' do
        expect(described_class.warn_environment?).to eq(false)
        expect(described_class.sandbox_environment?).to eq(false)
      end
    end
  end
end
