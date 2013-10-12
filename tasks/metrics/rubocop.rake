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
      config = Develry.project.rubocop
      begin
        Rubocop::CLI.new.run(%W[--config #{config.config_file.to_s}])
      rescue Encoding::CompatibilityError => exception
        Develry.notify exception.message
      end
    else
      $stderr.puts 'Rubocop is disabled'
    end
  end
end
