# encoding: utf-8

namespace :metrics do
  desc 'Check with code style guide'
  task :rubocop do
    begin
      require 'rubocop'
      config = Devtools.project.rubocop
      begin
        Rubocop::CLI.new.run(%W[--config #{config.config_file.to_s}])
      rescue Encoding::CompatibilityError => exception
        Devtools.notify exception.message
      end
    rescue LoadError
      $stderr.puts 'In order to run rubocop, you must: gem install rubocop'
    end
  end
end
