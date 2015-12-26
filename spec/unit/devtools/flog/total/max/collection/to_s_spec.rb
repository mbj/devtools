RSpec.describe Devtools::Flog::Total::Collection, '#to_s' do
  subject { described_class.new([foo, bar]) }

  let(:foo) { instance_double(Devtools::Flog::Total, to_s: 'foo') }
  let(:bar) { instance_double(Devtools::Flog::Total, to_s: 'bar') }

  its(:to_s) { should eql("bar\nfoo") }
end
