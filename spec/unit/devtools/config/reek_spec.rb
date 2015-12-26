RSpec.describe Devtools::Config::Reek do
  let(:object) { described_class.new(Devtools.root.join('config')) }

  it 'defaults to all files in ./app and ./lib' do
    expect(object.files).to eql('{app,lib}/**/*.rb')
  end
end
