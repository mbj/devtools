target_gemfile = Devtools.project.shared_gemfile_path
source_gemfile = Devtools.shared_gemfile_path

project_root  = Devtools.project.root
source_config = Devtools.default_config_path

namespace :devtools do
  desc 'Sync Gemfile.devtools with gem'
  task :sync  do
    cp source_gemfile, target_gemfile, :verbose => true
  end

  desc "Copy default configs and Gemfile.devtools to #{project_root}"
  task :init => [ :sync ]  do
    cp_r source_config, project_root, :verbose => true
  end
end

desc 'Default: run all specs'
task :default => [ :spec ]
