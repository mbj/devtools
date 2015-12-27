RSpec.describe Devtools::Reek::Proxy, '#to_result' do
  let(:config_file) { 'reek.yml'                        }
  let(:files)       { %w[foo.rb bar.rb]                 }
  let(:cli)         { ['--config', config_file, *files] }

  let(:reek) do
    instance_double(::Reek::CLI::Application, execute: status_code)
  end

  let(:proxy) do
    described_class.new(config_file: config_file, files: files)
  end

  before do
    allow(::Reek::CLI::Application).to receive(:new).with(cli).and_return(reek)
  end

  context 'when status code is 0' do
    let(:status_code) { 0 }

    it 'executes reek and wraps status code' do
      expect(proxy.to_result).to eql(Devtools::Reek::Result.new(status: 0))
    end
  end

  context 'when status code is 1' do
    let(:status_code) { 1 }

    it 'executes reek and wraps status code' do
      expect(proxy.to_result).to eql(Devtools::Reek::Result.new(status: 1))
    end
  end
end
