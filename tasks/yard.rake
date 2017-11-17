begin
  require 'yard'

  YARD::Rake::YardocTask.new
rescue LoadError
  task :yard do
    warn 'In order to run yard, you must: gem install yard'
  end
end
