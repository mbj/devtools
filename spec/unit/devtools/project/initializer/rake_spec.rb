describe Devtools::Project::Initializer::Rake do
  describe '.call' do
    subject do
      described_class.call
    end

    it 'performs expected rake initialization' do
      path_a = instance_double(Pathname)
      path_b = instance_double(Pathname)

      expect(FileList).to receive(:glob)
        .with(Devtools.root.join('tasks/**/*.rake').to_s)
        .and_return([path_a, path_b])

      expect(Rake.application).to receive(:add_import).with(path_a)
      expect(Rake.application).to receive(:add_import).with(path_b)

      expect(subject).to be(described_class)
    end
  end
end
