RSpec.describe Devtools::Flog::Result, '#at_threshold?' do
  subject(:result) do
    described_class.new(
      totals: Devtools::Flog::Total::Collection.new(totals),
      threshold: 1.1
    )
  end

  context 'when all totals below threshold' do
    let(:totals) { [instance_double(Devtools::Flog::Total, score: 1.0)] }

    it { should_not be_at_threshold }
  end

  context 'when all totals above threshold' do
    let(:totals) { [instance_double(Devtools::Flog::Total, score: 1.2)] }

    it { should_not be_at_threshold }
  end

  context 'when largest total equals threshold' do
    let(:totals) do
      [
        instance_double(Devtools::Flog::Total, score: 1.0),
        instance_double(Devtools::Flog::Total, score: 1.1)
      ]
    end

    it { should be_at_threshold }
  end
end
