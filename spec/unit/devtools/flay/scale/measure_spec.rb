describe Devtools::Flay::Scale, '#measure' do
  subject(:measure) { instance.measure }

  let(:minimum_mass) { 0 }
  let(:files)        { [instance_double(File)] }
  let(:flay_masses) { { 0 => 5, 1 => 10 } }

  let(:instance) do
    described_class.new(minimum_mass: minimum_mass, files: files)
  end

  let(:flay_hashes) do
    {
      0 => instance_double(Array, size: 3),
      1 => instance_double(Array, size: 11)
    }
  end

  let(:flay) do
    instance_double(
      ::Flay,
      analyze: nil,
      masses:  flay_masses,
      hashes:  flay_hashes
    )
  end

  before do
    allow(::Flay).to receive(:new).with(mass: minimum_mass).and_return(flay)
    allow(flay).to receive(:process).with(*files)
  end

  it { should eql([Rational(5, 3), Rational(10, 11)]) }

  context 'when minimum mass is not 0' do
    let(:minimum_mass) { 1 }

    specify do
      measure
      expect(::Flay).to have_received(:new).with(mass: 1)
    end
  end
end
