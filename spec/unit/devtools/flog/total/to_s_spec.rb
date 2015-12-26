RSpec.describe Devtools::Flog::Total, '#to_s' do
  subject { described_class.new('Foo#bar', 1.23) }

  its(:to_s) { should eql('     1.2: Foo#bar') }
end
