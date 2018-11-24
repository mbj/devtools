# frozen_string_literal: true

describe Devtools::Rake::Flay, '#verify' do
  let(:tempfile)    { Tempfile.new(%w[file .rb], Dir.mktmpdir) }
  let(:file)        { Pathname(tempfile.path)                  }
  let(:directories) { [file.dirname.to_s]                      }

  let(:ruby) do
    <<-ERUBY
    def foo; end
    def bar; end
    ERUBY
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
    let(:options) do
      { threshold: 3, total_score: 3, lib_dirs: directories, excludes: [] }
    end

    let(:instance) { described_class.new(options) }

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
    let(:instance) do
      described_class.new(
        threshold: 0,
        total_score: 0,
        lib_dirs: directories,
        excludes: []
      )
    end

    specify do
      expect { instance.verify }
        .to raise_error(SystemExit)
        .with_message('Flay total is now 3, but expected 0')
    end
  end

  context 'when threshold is too high' do
    let(:instance) do
      described_class.new(
        threshold: 1000,
        total_score: 0,
        lib_dirs: directories,
        excludes: []
      )
    end

    specify do
      expect { instance.verify }
        .to raise_error(SystemExit)
        .with_message('Adjust flay threshold down to 3')
    end
  end

  context 'when total is too high' do
    let(:instance) do
      described_class.new(
        threshold: 3,
        total_score: 50,
        lib_dirs: directories,
        excludes: []
      )
    end

    specify do
      expect { instance.verify }
        .to raise_error(SystemExit)
        .with_message('Flay total is now 3, but expected 50')
    end
  end

  context 'when duplicate mass is greater than 0' do
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
      <<~REPORT
        Total score (lower is better) = 10

        1) Similar code found in :defn (mass = 10)
          #{file}:1
          #{file}:5
      REPORT
    end

    let(:instance) do
      described_class.new(
        threshold: 3,
        total_score: 5,
        lib_dirs: directories,
        excludes: []
      )
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

    let(:instance) do
      described_class.new(
        threshold: 5,
        total_score: 8,
        lib_dirs: directories,
        excludes: []
      )
    end

    it 'sums masses for total' do
      expect { instance.verify }.to_not raise_error
    end
  end

  context 'when no duplication masses' do
    let(:ruby) { '' }
    let(:instance) do
      described_class.new(
        threshold: 0,
        total_score: 0,
        lib_dirs: directories,
        excludes: []
      )
    end

    specify do
      expect { instance.verify }.to_not raise_error
    end
  end
end
