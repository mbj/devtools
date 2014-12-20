# encoding: utf-8

namespace :metrics do
  desc 'Check with code style guide'
  task :rubocop do
    require 'rubocop'
    config = Devtools.project.rubocop
    begin
      RuboCop::CLI.new.run(%W[--config #{config.config_file.to_s}])
    rescue Encoding::CompatibilityError => exception
      Devtools.notify_metric_violation exception.message
    end
  end
end
