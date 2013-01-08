target = Devtools.project.shared_gemfile_path
source = Devtools.shared_gemfile_path

namespace :devtools do
  desc 'Sync Gemfile.devtools with gem'
  task :sync  do
    cp source, target, :verbose => true
  end

  desc 'Prepare project with create config file'
  task :prepare => :sync  do
    FileUtils.mkdir_p Devtools.project.config_dir
    ['Flay', 'Mutant', 'Flog', 'Roodi', 'Yardstick'].each do |config|
      Devtools::Config.const_get(config).new(Devtools.project).prepare_file
    end
  end
end

desc 'Default: run all specs'
task :default => [:spec]
