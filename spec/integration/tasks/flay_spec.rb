require 'spec_helper'

describe Devtools::Tasks::Flay, "#call" do 
  let(:project) { Devtools.project }
  let(:config) { project.flay }
  subject { Devtools::Tasks::Flay.call(config, project) }

  it { should eql nil }

end
