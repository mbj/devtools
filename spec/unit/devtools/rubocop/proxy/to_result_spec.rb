RSpec.describe Devtools::Rubocop::Proxy, '#to_result' do
  let(:config_file) { 'rubocop.yml'                   }
  let(:dir)         { 'lib'                           }
  let(:cli)         { ['--config', config_file, dir]  }
  let(:rubocop)     { instance_double(::RuboCop::CLI) }

  let(:proxy) do
    described_class.new(config_file: config_file, directory: dir)
  end

  before do
    allow(::RuboCop::CLI).to receive(:new).and_return(rubocop)
    allow(rubocop).to receive(:run).with(cli).and_return(status_code)
  end

  context 'when status code is 0' do
    let(:status_code) { 0 }

    it 'executes rubocop and wraps status code' do
      expect(proxy.to_result).to eql(Devtools::Rubocop::Result.new(status: 0))
    end
  end

  context 'when status code is 1' do
    let(:status_code) { 1 }

    it 'executes rubocop and wraps status code' do
      expect(proxy.to_result).to eql(Devtools::Rubocop::Result.new(status: 1))
    end
  end
end
