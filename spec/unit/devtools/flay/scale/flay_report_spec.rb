describe Devtools::Flay::Scale, '#flay_report' do
  subject(:instance) { described_class.new(minimum_mass: 0, files: []) }

  let(:flay) do
    instance_double(::Flay, process: nil, analyze: nil, masses: {})
  end

  before do
    allow(::Flay).to receive(:new).with(mass: 0).and_return(flay)
  end

  specify do
    allow(flay).to receive(:report)
    instance.flay_report
    expect(flay).to have_received(:report)
  end
end
