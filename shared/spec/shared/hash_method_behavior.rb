shared_examples_for 'a hash method' do
  it_should_behave_like 'an idempotent method'

  it 'is a Fixnum' do
    should be_instance_of(Fixnum) # rubocop:disable Lint/UnifiedInteger
  end
end
