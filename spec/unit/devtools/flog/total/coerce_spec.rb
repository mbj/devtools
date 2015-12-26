RSpec.describe Devtools::Flog::Total, '.coerce' do
  subject { described_class.coerce('Foo#bar', 1.25) }

  it { should eql(described_class.new('Foo#bar', 1.3)) }
end
