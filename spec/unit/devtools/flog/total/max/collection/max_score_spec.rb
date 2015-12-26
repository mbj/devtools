RSpec.describe Devtools::Flog::Total::Collection, '#max_score' do
  subject { described_class.new([one, two, three]) }

  let(:one)   { instance_double(Devtools::Flog::Total, score: 2.4) }
  let(:two)   { instance_double(Devtools::Flog::Total, score: 4.5) }
  let(:three) { instance_double(Devtools::Flog::Total, score: 3.2) }

  its(:max_score) { should eql(4.5) }
end
