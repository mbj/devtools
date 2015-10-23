shared_examples_for 'an #each method' do
  it_should_behave_like 'a command method'

  context 'with no block' do
    subject { object.each }

    it { should be_instance_of(to_enum.class) }

    it 'yields the expected values' do
      expect(subject.to_a).to eql(object.to_a)
    end
  end
end
