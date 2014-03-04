# encoding: utf-8

namespace :metrics do
  desc 'Check with code style guide'
  task :rubocop do
    enabled = begin
      require 'rubocop'
    rescue LoadError, NotImplementedError
      false
    end

    if enabled
      require 'rubocop'
      config = Devtools.project.rubocop
      begin
        Rubocop::CLI.new.run(%W[--config #{config.config_file.to_s}])
      rescue Encoding::CompatibilityError => exception
        Devtools.notify_metric_violation exception.message
      end
    else
      $stderr.puts 'Rubocop is disabled'
    end
  end
end
