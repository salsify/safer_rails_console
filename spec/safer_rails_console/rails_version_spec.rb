describe SaferRailsConsole::RailsVersion do
  before do
    stub_const("#{described_class.name}::RAILS_VERSION", Gem::Version.new(rails_version))

    # Reset memoized class instance variables - in practicality these should never change
    described_class.instance_variables.each do |var|
      described_class.instance_variable_set(var, nil)
    end
  end

  describe "Unsupported version" do
    let(:rails_version) { '4.2.0' }

    it "responds correctly" do
      expect(described_class.supported?).to eq(false)
      expect(described_class.five_zero?).to eq(false)
      expect(described_class.five_one?).to eq(false)
      expect(described_class.five_two?).to eq(false)
      expect(described_class.six_zero?).to eq(false)
    end
  end

  describe "5.0" do
    let(:rails_version) { '5.0.0' }

    it "responds correctly" do
      expect(described_class.supported?).to eq(true)
      expect(described_class.five_zero?).to eq(true)
      expect(described_class.five_one?).to eq(false)
      expect(described_class.five_two?).to eq(false)
      expect(described_class.six_zero?).to eq(false)
    end
  end

  describe "5.1" do
    let(:rails_version) { '5.1.0' }

    it "responds correctly" do
      expect(described_class.supported?).to eq(true)
      expect(described_class.five_zero?).to eq(false)
      expect(described_class.five_one?).to eq(true)
      expect(described_class.five_two?).to eq(false)
      expect(described_class.six_zero?).to eq(false)
    end
  end

  describe "5.2" do
    let(:rails_version) { '5.2.0' }

    it "responds correctly" do
      expect(described_class.supported?).to eq(true)
      expect(described_class.five_zero?).to eq(false)
      expect(described_class.five_one?).to eq(false)
      expect(described_class.five_two?).to eq(true)
      expect(described_class.six_zero?).to eq(false)
    end
  end

  describe "6.0" do
    let(:rails_version) { '6.0.0' }

    it "responds correctly" do
      expect(described_class.supported?).to eq(true)
      expect(described_class.five_zero?).to eq(false)
      expect(described_class.five_one?).to eq(false)
      expect(described_class.five_two?).to eq(false)
      expect(described_class.six_zero?).to eq(true)
    end
  end
end
