begin
  require 'yard'

  YARD::Rake::YardocTask.new
rescue LoadError
  task :yard do
    $stderr.puts 'In order to run yard, you must: gem install yard'
  end
end
