# encoding: utf-8

begin
  require 'reek/rake/task'


  allowed_failures = %w(mri-1.9.2 rbx-1.7.7)
  allow_failure = allowed_failures.include?(Devtools.rvm)

  namespace :metrics do
    Reek::Rake::Task.new do |t|
      # reek has some problems under rbx in 1.8 mode that cause the underlying
      # script to raise an exception. Rather than halt the "rake ci" process due
      # to one bug, we choose to ignore it in this specific case until reek can be
      # fixed.
      t.fail_on_error = !allow_failure
    end
  end
rescue LoadError
  namespace :metrics do
    task :reek do
      $stderr.puts 'Reek is not available. In order to run reek, you must: gem install reek'
    end
  end
end
