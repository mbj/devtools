describe Devtools::Project::Initializer::Rspec do
  let(:spec_root)         { instance_double(Pathname) }
  let(:unit_test_timeout) { instance_double(Float)    }

  let(:project) do
    instance_double(
      Devtools::Project,
      spec_root: spec_root,
      devtools:  instance_double(
        Devtools::Config::Devtools,
        unit_test_timeout: unit_test_timeout
      )
    )
  end

  describe '.call' do
    subject do
      described_class.call(project)
    end

    it 'performs expected rspec initialization' do
      called = false
      example = -> { called = true }

      expect(Devtools).to receive(:require_files)
        .with(Devtools.root.join('shared/spec'), '{shared,support}/**/*.rb')

      expect(Devtools).to receive(:require_files)
        .with(spec_root, '{shared,support}/**/*.rb')

      expect(Timeout).to receive(:timeout).with(unit_test_timeout) do |&block|
        block.call
      end

      expect(RSpec.configuration).to receive(:around)
        .with(file_path: %r{\bspec/unit/})
        .and_yield(example)

      expect(subject).to be(described_class)

      expect(called).to be(true)
    end
  end
end
