# encoding: utf-8

namespace :metrics do
  desc 'Run rubocop'
  task :rubocop do
    require 'rubocop'
    config = Devtools.project.rubocop
    Rubocop::CLI.new.run(['--config', config.config_file.to_s])
  end
end
