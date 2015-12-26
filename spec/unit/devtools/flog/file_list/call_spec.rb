RSpec.describe Devtools::Flog::FileList, '.call' do
  let(:file_list) { described_class.call([root_dir]) }

  let(:root_dir)   { Dir.mktmpdir                                 }
  let(:nested_dir) { Dir.mktmpdir(nil, root_dir)                  }
  let!(:file1)     { Tempfile.new(%w[one .rb], root_dir)          }
  let!(:file2)     { Tempfile.new(%w[two .rake], nested_dir)      }
  let!(:file3)     { Tempfile.new(%w[three .gemspec], nested_dir) }

  it 'finds .rb and .rake files recursively' do
    expect(file_list).to match_array([file1.path, file2.path])
  end
end
