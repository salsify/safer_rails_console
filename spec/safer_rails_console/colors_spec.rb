RSpec.describe SaferRailsConsole::Colors do
  specify "color constants are defined" do
    expect(described_class::NONE).to eq(0)
    expect(described_class::RED).to eq(31)
    expect(described_class::GREEN).to eq(32)
    expect(described_class::YELLOW).to eq(33)
    expect(described_class::BLUE).to eq(34)
    expect(described_class::PINK).to eq(35)
    expect(described_class::CYAN).to eq(36)
    expect(described_class::WHITE).to eq(37)
  end

  context "#color_text" do
    let(:sample_text) { 'some input' }
    let(:expected_output) { "\e[#{SaferRailsConsole::Colors::RED}m#{sample_text}\e[0m" }

    it "is defined when included in a class" do
      expect(ClassWithColors.method_defined?(:color_text)).to eq(true)
    end

    it "outputs colored text" do
      expect(ClassWithColors.new.color_text(sample_text, ClassWithColors::RED)).to eq(expected_output)
    end
  end

  class ClassWithColors
    include SaferRailsConsole::Colors
  end
end
