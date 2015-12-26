RSpec.describe Devtools::Flog::Total::Collection, '.coerce' do
  let(:collection) do
    described_class.coerce(
      'Foo#baz' => 2.0,
      'Foo#bar' => 1.0,
      'Foo#qux' => 3.0
    )
  end

  it 'coerces into Total objects' do
    expect(collection).to eql(
      described_class.new([
        Devtools::Flog::Total.new('Foo#bar', 1.0),
        Devtools::Flog::Total.new('Foo#baz', 2.0),
        Devtools::Flog::Total.new('Foo#qux', 3.0)
      ])
    )
  end
end
