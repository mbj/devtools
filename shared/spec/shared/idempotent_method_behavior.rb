# encoding: utf-8

shared_examples_for 'an idempotent method' do
  it 'is idempotent' do
    first = subject
    fail 'RSpec not configured for threadsafety' unless RSpec.configuration.threadsafe?
    mutex = __memoized.instance_variable_get(:@mutex)
    memoized = __memoized.instance_variable_get(:@memoized)
    mutex.synchronize { memoized.delete(:subject) }
    should equal(first)
  end
end
