require 'spec_helper'

describe Devtools::Tasks::Flay, "#call" do 
  let(:project) { Devtools.project }
  let(:config) { project.flay }

  it "returns ..." do 
    expect(described_class.call(config, project)).to be_nil
  end

end
