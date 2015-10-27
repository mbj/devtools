describe Devtools do
  describe '.project' do
    specify do
      expect(Devtools.project).to equal(Devtools::PROJECT)
    end
  end

  describe '.init_rake_tasks' do
    specify do
      expect(Devtools::Project::Initializer::Rake).to receive(:call)
      expect(Devtools.init_rake_tasks).to be(Devtools)
    end
  end
end
