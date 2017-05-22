describe Devtools::Flay::Scale, '#measure' do
  subject(:measure) { described_class.new(options).measure }

  let(:minimum_mass)    { 0                                            }
  let(:file)            { Tempfile.new(%w[file rb])                    }
  let(:path)            { file.path                                    }
  let(:files)           { [path]                                       }
  let(:options)         { { minimum_mass: minimum_mass, files: files } }

  let(:source) do
    <<-RUBY
    def foo
      :hi
    end

    def bar
      :hi
    end
    RUBY
  end

  let(:report) do
    <<-REPORT
Total score (lower is better) = 6

Similar code found in :defn (mass = 6)
  #{path}:1
  #{path}:5
REPORT
  end

  around(:each) do |example|
    file.write(source)
    file.close

    example.run

    file.unlink
  end

  it { should be_an_instance_of(Devtools::Flay::Result) }

  its(:relative_masses) { should eql([Rational(3, 1)]) }

  its(:report) { should eql(report) }
end
