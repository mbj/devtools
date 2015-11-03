describe Devtools::Rake::Flog, '#verify' do
  subject(:instance) { described_class.new(config) }

  let(:tempfile)    { Tempfile.new(%w[file .rb], Dir.mktmpdir) }
  let(:file)        { Pathname(tempfile.path)                  }
  let(:directories) { [file.dirname.to_s]                      }

  let(:config) do
    instance_double(
      Devtools::Config::Flog,
      threshold: threshold,
      lib_dirs: directories
    )
  end

  let(:ruby) do
    <<-ERUBY
class Foo
  i :use
  fancy :macros
  alias_method :fooooo, :foo

  def baz
    qux
    norf
    1
  end

  def foo
    baz
    2
  end
end
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

  context 'when flog complexity is exceeded' do
    let(:threshold) { 0.0 }
    let(:report) do
      <<-EOF
     2.3: Foo#baz
     1.3: Foo#foo
EOF
    end

    it 'fails saying flog complexity > 0.0' do
      expect { instance.verify }
        .to raise_error(SystemExit)
        .with_message('2 methods have a flog complexity > 0.0')
        .and output(report).to_stdout
    end
  end

  context 'when threshold is higher than current complexity' do
    let(:threshold) { 4.0 }
    let(:report) { '' }

    it 'fails saying adjust down flog complexity' do
      expect { instance.verify }
        .to raise_error(SystemExit)
        .with_message('Adjust flog score down to 2.3')
        .and output('').to_stdout
    end
  end

  context 'when threshold is exactly correct' do
    let(:threshold) { 2.25 }
    let(:report) { '' }

    it 'does not fail or report' do
      expect { instance.verify }
        .to output('').to_stdout
    end
  end

  context 'when no contents' do
    let(:ruby) { '' }
    let(:report) { '' }
    let(:threshold) { 0.0 }

    it 'does not fail or report' do
      expect { instance.verify }
        .to output('').to_stdout
    end
  end
end
