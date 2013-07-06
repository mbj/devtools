# encoding: utf-8

namespace :metrics do
  desc 'Run rubocop'
  task :rubocop do
    require 'rubocop'

    project = Devtools.project
    config  = project.rubocop

    args   = ARGV.drop(1) << '--config' << config.config_file.to_s
    result = Rubocop::CLI.new.run(args)

    exit result if result.nonzero?
  end
end
