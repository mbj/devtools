describe Devtools::Rake::Flay, '#verify' do
  let(:tempfile)    { Tempfile.new(%w[file .rb], Dir.mktmpdir) }
  let(:file)        { Pathname(tempfile.path)                  }
  let(:directories) { [file.dirname.to_s]                      }
  let(:instance)    { described_class.new(config)              }

  let(:ruby) do
    <<-ERUBY
    def foo; end
    def bar; end
    ERUBY
  end

  let(:config) do
    instance_double(
      Devtools::Config::Flay,
      threshold:   threshold,
      total_score: total_score,
      lib_dirs:    directories,
      excludes:    []
    )
  end

  around(:each) do |example|
    begin
      # silence other flay output
      $stdout = $stderr = StringIO.new

      tempfile.write(ruby)
      tempfile.close

      example.run
    ensure
      $stdout = STDOUT
      $stderr = STDERR

      file.unlink
    end
  end

  context 'reporting' do
    let(:threshold)   { 3 }
    let(:total_score) { 3 }

    it 'measures total mass' do
      allow(::Flay).to receive(:new).and_call_original

      instance.verify

      expect(::Flay).to have_received(:new).with(hash_including(mass: 0))
    end

    it 'does not report the files it is processing' do
      expect { instance.verify }.to_not output(/Processing #{file}/).to_stderr
    end
  end

  context 'when theshold is too low' do
    let(:threshold)   { 0 }
    let(:total_score) { 0 }

    specify do
      expect { instance.verify }
        .to raise_error(SystemExit)
        .with_message('Flay total is now 3, but expected 0')
    end
  end

  context 'when threshold is too high' do
    let(:threshold)   { 1000 }
    let(:total_score) { 3    }

    specify do
      expect { instance.verify }
        .to raise_error(SystemExit)
        .with_message('Adjust flay threshold down to 3')
    end
  end

  context 'when total is too high' do
    let(:threshold)   { 3  }
    let(:total_score) { 50 }

    specify do
      expect { instance.verify }
        .to raise_error(SystemExit)
        .with_message('Flay total is now 3, but expected 50')
    end
  end

  context 'when duplicate mass is greater than 0' do
    let(:threshold)   { 3 }
    let(:total_score) { 5 }

    let(:ruby) do
      <<-ERUBY
      def foo
        :hi if baz?
      end

      def bar
        :hi if baz?
      end
      ERUBY
    end

    let(:report) do
      <<-REPORT
Total score (lower is better) = 10

Similar code found in :defn (mass = 10)
  #{file}:1
  #{file}:5
REPORT
    end

    specify do
      expect { instance.verify }
        .to raise_error(SystemExit)
        .with_message('1 chunks have a duplicate mass > 3')
    end

    specify do
      expect { instance.verify }
        .to raise_error(SystemExit)
        .and output(report).to_stdout
    end
  end

  context 'when multiple duplicate masses' do
    let(:threshold)   { 5 }
    let(:total_score) { 8 }

    let(:ruby) do
      <<-ERUBY
      def foo; end
      def bar; end

      class Foo
        def initialize
          @a = 1
        end
      end
      class Bar
        def initialize
          @a = 1
        end
      end
      ERUBY
    end

    it 'sums masses for total' do
      expect { instance.verify }.to_not raise_error
    end
  end

  context 'when no duplication masses' do
    let(:threshold)   { 0  }
    let(:total_score) { 0  }
    let(:ruby)        { '' }

    specify do
      expect { instance.verify }.to_not raise_error
    end
  end
end
