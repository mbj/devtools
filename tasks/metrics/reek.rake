# encoding: utf-8

namespace :metrics do
  if Devtools.rvm == 'mri-2.0.0'
    task :reek do
      $stderr.puts "Reek::Rake::Task does not work under #{Devtools.rvm} currently and is disabled"
    end
  else
    begin
      require 'reek/rake/task'

      Reek::Rake::Task.new do |reek|
        config =
          if File.exist?("config/site.reek")
            warn "config/site.reek is deprecated. please 'mv config/site.reek config/reek.yml'"
            "site.reek"
          else
            "reek.yml"
          end

        # silence output for files with no errors
        reek.reek_opts = "--quiet -c config/#{config}"
      end
    rescue LoadError
      task :reek do
        $stderr.puts 'Reek is not available. In order to run reek, you must: gem install reek'
      end
    end
  end
end
