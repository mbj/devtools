describe Devtools::Rake::Rubocop, '#verify' do
  subject(:instance) do
    described_class.new(directory: directory, config: task_config)
  end

  let(:rubocop_yml) { Tempfile.new(%w[rubocop .yml], Dir.mktmpdir) }
  let(:config_file) { Pathname(rubocop_yml.path)                   }
  let(:config)      { 'FileName: { Enabled: false }'               }
  let(:tempfile)    { Tempfile.new(%w[file .rb], Dir.mktmpdir)     }
  let(:file)        { Pathname(tempfile.path)                      }
  let(:directory)   { file.dirname.to_s                            }
  let(:ruby)        { "def foo\n  end\n"                           }

  let(:task_config) do
    instance_double(Devtools::Config::Rubocop, config_file: config_file)
  end

  let(:report) do
    <<-EOF
Inspecting 1 file
W

Offenses:

#{file}:2:3: W: end at 2, 2 is not aligned with def at 1, 0.
  end
  ^^^

1 file inspected, 1 offense detected
EOF
  end

  around(:each) do |example|
    begin
      tempfile.write(ruby)
      tempfile.close

      rubocop_yml.write(config)
      rubocop_yml.close

      example.run
    ensure
      file.unlink
      config_file.unlink
    end
  end

  it 'fails with rubocop warnings' do
    expect { instance.verify }
      .to raise_error(RuntimeError).with_message('Rubocop not successful')
      .and output(report).to_stdout
  end

  context 'when rubocop passes' do
    let(:ruby) { "def foo\nend\n" }

    specify do
      expect { instance.verify }.to_not raise_error
    end
  end

  context 'when rubocop encounters an encoding error' do
    before do
      allow(RuboCop::CLI).to receive(:new)
        .and_raise(Encoding::CompatibilityError, 'incompatible')
    end

    it 'reports encoding error' do
      expect { instance.verify }
        .to raise_error(SystemExit).with_message('incompatible')
    end
  end
end
