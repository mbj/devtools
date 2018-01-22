RSpec.describe Devtools::Project do
  let(:object) { described_class.new(Devtools.root) }

  describe '#init_rspec' do
    subject { object.init_rspec }

    it 'calls the rspec initializer' do
      expect(Devtools::Project::Initializer::Rspec)
        .to receive(:call).with(Devtools.project)
      expect(subject).to be(object)
    end
  end

  {
    devtools:  Devtools::Config::Devtools,
    flay:      Devtools::Config::Flay,
    flog:      Devtools::Config::Flog,
    reek:      Devtools::Config::Reek,
    mutant:    Devtools::Config::Mutant,
    rubocop:   Devtools::Config::Rubocop,
    yardstick: Devtools::Config::Yardstick
  }.each do |name, klass|
    describe "##{name}" do
      subject { object.send(name) }

      specify { should eql(klass.new(Devtools.root.join('config'))) }
    end
  end

  describe '#spec_root' do
    subject { object.spec_root }

    specify { should eql(Devtools.root.join('spec')) }
  end
end
