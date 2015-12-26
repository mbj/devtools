RSpec.describe Devtools::Flog::Result, '#below_threshold?' do
  subject(:result) do
    described_class.new(
      totals:    totals,
      threshold: threshold
    )
  end

  let(:totals) do
    instance_double(Devtools::Flog::Total::Collection, max_score: 3.2)
  end

  context 'when threshold is below max score' do
    let(:threshold) { 3.1 }

    it { should_not be_below_threshold }
  end

  context 'when threshold is equal to max score' do
    let(:threshold) { 3.2 }

    it { should_not be_below_threshold }
  end

  context 'when threshold is above max score' do
    let(:threshold) { 3.3 }

    it { should be_below_threshold }
  end
end
