target = Devtools.project.shared_gemfile_path
source = Devtools.shared_gemfile_path


namespace :devtools do
  desc 'Update devtools assets in project'
  task :update => [target]

  file(target => source) do |t|
    cp source, target, :verbose => true
  end
end

desc 'Default: run all specs'
task :default => [:spec]
