describe Devtools do
  describe '.project' do
    specify do
      expect(Devtools.project).to equal(Devtools::PROJECT)
    end
  end
end
