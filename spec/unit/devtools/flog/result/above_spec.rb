RSpec.describe Devtools::Flog::Result, '#above' do
  subject(:result) do
    described_class.new(
      totals:    Devtools::Flog::Total::Collection.new([one, two, three]),
      threshold: 2.0
    )
  end

  let(:one)   { instance_double(Devtools::Flog::Total, score: 1.0) }
  let(:two)   { instance_double(Devtools::Flog::Total, score: 2.0) }
  let(:three) { instance_double(Devtools::Flog::Total, score: 3.0) }

  its(:above) { should eql(Devtools::Flog::Total::Collection.new([three])) }
end
