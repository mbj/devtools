require 'devtools/spec_helper'
require 'tempfile'
require 'tmpdir'

if ENV['COVERAGE'] == 'true'
  formatter = [SimpleCov::Formatter::HTMLFormatter]
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(formatter)

  SimpleCov.start do
    command_name 'spec:unit'

    add_filter 'config'
    add_filter 'spec'
    add_filter 'vendor'

    minimum_coverage 100
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expect_with|
    expect_with.syntax = :expect
  end
end
