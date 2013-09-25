require 'spec_helper'

describe Devtools::Task::Flay, ".call" do 
  let(:project) { Devtools.project }
  let(:config) { project.flay }
  subject { Devtools::Task::Flay.call(config, project) }

  it { should eql nil }

end
