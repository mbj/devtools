# encoding: utf-8

namespace :metrics do
  desc 'Run rubocop'
  task :rubocop do
    require 'rubocop'

    config = Devtools.project.rubocop
    args   = ARGV.drop(1) << '--config' << config.config_file.to_s

    Rubocop::CLI.new.run(args)
  end
end
