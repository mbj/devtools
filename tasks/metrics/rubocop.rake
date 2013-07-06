# encoding: utf-8

namespace :metrics do
  desc 'Run rubocop'
  task :rubocop do
    require 'rubocop'

    # TODO: add config file switch
    args   = ARGV.drop(1)
    result = Rubocop::CLI.new.run(args)

    exit result if result.nonzero?
  end
end
