describe Devtools::Project::Initializer::Rspec do
  let(:spec_root)         { Devtools.root.join('spec') }
  let(:unit_test_timeout) { instance_double(Float)     }

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

      expect(Dir).to receive(:glob)
        .with(Devtools.root.join('shared/spec/{shared,support}/**/*.rb'))
        .and_return(%w[shared-a shared-b])

      expect(Kernel).to receive(:require).with('shared-a')
      expect(Kernel).to receive(:require).with('shared-b')

      expect(Dir).to receive(:glob)
        .with(Devtools.root.join('spec/{shared,support}/**/*.rb'))
        .and_return(%w[support-a support-b])

      expect(Kernel).to receive(:require).with('support-a')
      expect(Kernel).to receive(:require).with('support-b')

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
