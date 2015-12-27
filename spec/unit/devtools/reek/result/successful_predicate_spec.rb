RSpec.describe Devtools::Reek::Result, '#successful?' do
  subject { described_class.new(status: code) }

  context 'when status code is 0' do
    let(:code) { 0 }

    it { should be_successful }
  end

  context 'when status code is 2' do
    let(:code) { 2 }

    it { should_not be_successful }
  end
end
