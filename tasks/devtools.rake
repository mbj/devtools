target = Devtools.project.shared_gemfile_path
source = Devtools.shared_gemfile_path


namespace :devtools do
  desc 'Sync Gemfile.devtools with gem'
  task :sync  do
    cp source, target, :verbose => true
  end
end

desc 'Default: run all specs'
task :default => [:spec]
