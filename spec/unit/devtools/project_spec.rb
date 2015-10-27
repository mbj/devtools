RSpec.describe Devtools::Project do
  describe '#init_rspec' do
    subject { Devtools.project.init_rspec }

    it 'calls the rspec initializer' do
      expect(Devtools::Project::Initializer::Rspec).to receive(:call).with(Devtools.project)
      expect(subject).to be(Devtools.project)
    end
  end
end
