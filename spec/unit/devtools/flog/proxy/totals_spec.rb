RSpec.describe Devtools::Flog::Proxy, '#totals' do
  let(:proxy) { described_class.new(files)            }
  let(:files) { %w[file1.rb file2.rb]                 }
  let(:flog)  { instance_double(Flog, totals: totals) }

  let(:totals) do
    {
      'Foo#baz'  => 7.12345,
      'Foo#bar'  => 2.567
    }
  end

  before do
    allow(::Flog).to receive(:new).with(methods: true).and_return(flog)
    allow(flog).to receive(:flog).with(*files)
  end

  it 'analyzes with flog' do
    proxy.totals

    expect(flog).to have_received(:flog)
  end

  it 'wraps results in totals' do
    expect(proxy.totals).to eql(
      Devtools::Flog::Total::Collection.new([
        Devtools::Flog::Total.new('Foo#bar', 2.6),
        Devtools::Flog::Total.new('Foo#baz', 7.1)
      ])
    )
  end
end
