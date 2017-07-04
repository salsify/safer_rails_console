describe SaferRailsConsole::Colors do
  let(:class_with_colors) do
    class ClassWithColors
      include SaferRailsConsole::Colors
    end

    ClassWithColors
  end

  let(:sample_text) { 'some input' }
  let(:expected_output) { "\e[#{described_class::RED}m#{sample_text}\e[0m" }

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

  context ".color_text" do
    it "outputs colored text" do
      expect(described_class.color_text(sample_text, described_class::RED)).to eq(expected_output)
    end
  end

  context "#color_text" do
    it "is defined when included in a class" do
      expect(class_with_colors.method_defined?(:color_text)).to eq(true)
    end

    it "outputs colored text" do
      expect(class_with_colors.new.color_text(sample_text, class_with_colors::RED)).to eq(expected_output)
    end
  end
end
