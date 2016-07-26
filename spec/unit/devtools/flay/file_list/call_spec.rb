describe Devtools::Flay::FileList, '.call' do
  subject(:output) { described_class.call([tmpdir.to_s].freeze, [exclude]) }

  let(:tmpdir)     { Dir.mktmpdir                     }
  let(:one)        { Pathname(tmpdir).join('1.rb')    }
  let(:two)        { Pathname(tmpdir).join('2.erb')   }
  let(:three)      { Pathname(tmpdir).join('3.rb')    }
  let(:exclude)    { Pathname(tmpdir).join('3*').to_s }

  around(:each) do |example|
    [one, two, three].map(&FileUtils.method(:touch))

    example.run

    FileUtils.rm_rf(tmpdir)
  end

  it { should eql(Set.new([one, two])) }
end
