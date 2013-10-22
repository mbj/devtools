require 'spec_helper'

describe Devtools::Tasks::Flay, "#call" do 
  let(:project) { Devtools.project }
  let(:config) { project.flay }
  subject { Devtools::Tasks::Flay.new(config, project).call }

  it { should eql nil }

end
