describe Devtools::Rake::Reek, '#verify' do
  subject(:instance) do
    described_class.new(config: task_config, files: [file.to_s])
  end

  let(:reek_yml)    { Tempfile.new(%w[reek .yml], Dir.mktmpdir) }
  let(:config_file) { Pathname(reek_yml.path)                   }
  let(:config)      { 'PrimaDonnaMethod: { enabled: false }'    }
  let(:tempfile)    { Tempfile.new(%w[file .rb], Dir.mktmpdir)  }
  let(:file)        { Pathname(tempfile.path)                   }
  let(:directories) { [file.dirname.to_s]                       }

  let(:task_config) do
    instance_double(Devtools::Config::Reek, config_file: config_file)
  end

  let(:ruby) do
    <<-ERUBY
    class Foo
      def bar!
      end
    end
    ERUBY
  end

  # rubocop:disable Metrics/LineLength
  let(:report) do
    <<-EOF
#{file} -- 1 warning:
  [1]:IrresponsibleModule: Foo has no descriptive comment [https://github.com/troessner/reek/blob/master/docs/Irresponsible-Module.md]
EOF
  end

  around(:each) do |example|
    begin
      # silence other flay output
      $stdout = $stderr = StringIO.new

      # reek CLI sets this and it infects rubocop depending on ordering
      rainbow = Rainbow.enabled

      tempfile.write(ruby)
      tempfile.close

      reek_yml.write(config)
      reek_yml.close

      example.run
    ensure
      $stdout = STDOUT
      $stderr = STDERR

      Rainbow.enabled = rainbow

      file.unlink
      config_file.unlink
    end
  end

  it 'prints report' do
    expect { instance.verify }
      .to raise_error(SystemExit)
      .and output(report).to_stdout
  end

  it 'fails with metric violation' do
    expect { instance.verify }
      .to raise_error(SystemExit)
      .with_message("\n\n!!! Reek has found smells - exiting!")
  end

  context 'when reek runs without violations' do
    let(:ruby) do
      <<-ERUBY
      # Foo is now a responsible module
      class Foo; end
      ERUBY
    end

    let(:report) { '' }

    it 'prints successful report' do
      expect { instance.verify }.to output(report).to_stdout
    end
  end
end
