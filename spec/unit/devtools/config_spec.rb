RSpec.describe Devtools::Config do

  describe '.attribute' do
    let(:raw) do
      {
        'a' => 'bar',
        'c' => []
      }

    end

    let(:config_path) { instance_double(Pathname) }

    let(:class_under_test) do
      expect(config_path).to receive(:file?)
        .and_return(file?)
      expect(config_path).to receive(:frozen?)
        .and_return(true)
      expect(config_path).to receive(:join)
        .with('bar.yml')
        .and_return(config_path)

      Class.new(described_class) do
        attribute :a, [String]
        attribute :b, [Array], default: []
        attribute :c, [TrueClass, FalseClass]

        const_set(:FILE, 'bar.yml')
      end
    end

    subject do
      class_under_test.new(config_path)
    end

    context 'on present config' do
      let(:class_under_test) do
        # Setup message expectation in a lasy way, not in a before
        # block to make sure the around hook setting timeouts from the
        # code under test is not affected.
        expect(YAML).to receive(:load_file)
          .with(config_path)
          .and_return(raw)

        expect(IceNine).to receive(:deep_freeze)
          .with(raw)
          .and_return(raw)

        super()
      end

      let(:file?) { true }

      it 'allows to receive existing keys' do
        expect(subject.a).to eql('bar')
      end

      it 'allows to receive absent keys with defaults' do
        expect(subject.b).to eql([])
      end

      it 'executes checks when configured' do
        expect { subject.c }.to raise_error(
          Devtools::Config::TypeError,
          'c: Got instance of Array expected TrueClass,FalseClass'
        )
      end
    end

    context 'on absent config' do
      let(:file?) { false }

      it 'defaults to absent keys' do
        expect(subject.b).to eql([])
      end
    end
  end
end
