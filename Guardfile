# encoding: utf-8

guard 'bundler' do
  watch('Gemfile')
  watch('Gemfile.lock')
  watch(%w{.+.gemspec\z})
end

guard :rspec do
  # Run all specs if configuration is modified
  watch('.rspec')              { 'spec' }
  watch('Guardfile')           { 'spec' }
  watch('Gemfile.lock')        { 'spec' }
  watch('spec/spec_helper.rb') { 'spec' }

  # Run all specs if supporting files are modified
  watch(%r{\Aspec/(?:fixtures|shared|support)/.+\.rb\z}) { 'spec' }

  # Run specs if associated app or lib code is modified
  watch(%r{\Alib/(.+)\.rb\z}) { |m| Dir["spec/{unit,integration}/#{m[1]}_spec.rb"] }

  # Run a spec if it is modified
  watch(%r{\Aspec/(?:unit|integration)/.+_spec\.rb\z})
end

guard :rubocop, cli: %w[--config config/rubocop.yml] do
  watch(%r{.+\.(?:rb|rake)\z})
  watch(%r{(?:.+/)?\.rubocop\.yml\z}) { |m| File.dirname(m[0]) }
end
