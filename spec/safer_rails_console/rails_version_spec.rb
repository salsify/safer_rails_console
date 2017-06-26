describe SaferRailsConsole::RailsVersion do
  before do
    stub_const("#{described_class.name}::RAILS_VERSION", Gem::Version.new(rails_version))

    # Reset memoized class instance variables - in practicality these should never change
    described_class.instance_variable_set :@is_four_one, nil
    described_class.instance_variable_set :@is_four_two, nil
    described_class.instance_variable_set :@is_five_zero, nil
    described_class.instance_variable_set :@is_five_one, nil
  end

  describe "Unsupported version" do
    let(:rails_version) { '4.0.0' }

    it "responds correctly" do
      expect(described_class.supported?).to eq(false)
      expect(described_class.four_one?).to eq(false)
      expect(described_class.four_two?).to eq(false)
      expect(described_class.five_zero?).to eq(false)
      expect(described_class.five_one?).to eq(false)
    end
  end

  describe "4.1" do
    let(:rails_version) { '4.1.0' }

    it "responds correctly" do
      expect(described_class.supported?).to eq(true)
      expect(described_class.four_one?).to eq(true)
      expect(described_class.four_two?).to eq(false)
      expect(described_class.five_zero?).to eq(false)
      expect(described_class.five_one?).to eq(false)
    end
  end

  describe "4.2" do
    let(:rails_version) { '4.2.0' }

    it "responds correctly" do
      expect(described_class.supported?).to eq(true)
      expect(described_class.four_one?).to eq(false)
      expect(described_class.four_two?).to eq(true)
      expect(described_class.five_zero?).to eq(false)
      expect(described_class.five_one?).to eq(false)
    end
  end

  describe "5.0" do
    let(:rails_version) { '5.0.0' }

    it "responds correctly" do
      expect(described_class.supported?).to eq(true)
      expect(described_class.four_one?).to eq(false)
      expect(described_class.four_two?).to eq(false)
      expect(described_class.five_zero?).to eq(true)
      expect(described_class.five_one?).to eq(false)
    end
  end

  describe "5.1" do
    let(:rails_version) { '5.1.0' }

    it "responds correctly" do
      expect(described_class.supported?).to eq(true)
      expect(described_class.four_one?).to eq(false)
      expect(described_class.four_two?).to eq(false)
      expect(described_class.five_zero?).to eq(false)
      expect(described_class.five_one?).to eq(true)
    end
  end
end
