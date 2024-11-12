# frozen_string_literal: true

describe SaferRailsConsole::RailsVersion do
  before do
    stub_const("#{described_class.name}::RAILS_VERSION", Gem::Version.new(rails_version))

    # Reset memoized class instance variables - in practicality these should never change
    described_class.instance_variables.each do |var|
      described_class.remove_instance_variable(var)
    end
  end

  describe "Unsupported version" do
    let(:rails_version) { '5.2.0' }

    it "responds correctly" do
      expect(described_class.supported?).to eq(false)
      expect(described_class.six_or_above?).to eq(false)
      expect(described_class.eight_or_above?).to eq(false)
    end
  end

  describe "6.0" do
    let(:rails_version) { '6.0.0' }

    it "responds correctly" do
      expect(described_class.supported?).to eq(true)
      expect(described_class.six_or_above?).to eq(true)
      expect(described_class.eight_or_above?).to eq(false)
    end
  end

  describe "6.1" do
    let(:rails_version) { '6.1.0' }

    it "responds correctly" do
      expect(described_class.supported?).to eq(true)
      expect(described_class.six_or_above?).to eq(true)
    end
  end

  describe "7.0" do
    let(:rails_version) { '7.0.0' }

    it "responds correctly" do
      expect(described_class.supported?).to eq(true)
      expect(described_class.six_or_above?).to eq(true)
      expect(described_class.eight_or_above?).to eq(false)
    end
  end

  describe "7.1" do
    let(:rails_version) { '7.1.0' }

    it "responds correctly" do
      expect(described_class.supported?).to eq(true)
      expect(described_class.six_or_above?).to eq(true)
      expect(described_class.eight_or_above?).to eq(false)
    end
  end

  describe "7.2" do
    let(:rails_version) { '7.2.0' }

    it "responds correctly" do
      expect(described_class.supported?).to eq(true)
      expect(described_class.six_or_above?).to eq(true)
      expect(described_class.eight_or_above?).to eq(false)
    end
  end

  describe "8.0" do
    let(:rails_version) { '8.0.0' }

    it "responds correctly" do
      expect(described_class.supported?).to eq(true)
      expect(described_class.six_or_above?).to eq(true)
      expect(described_class.eight_or_above?).to eq(true)
    end
  end
end
