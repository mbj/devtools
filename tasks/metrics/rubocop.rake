namespace :metrics do
  desc 'Check with code style guide'
  task :rubocop do
    config = Devtools.project.rubocop

    Devtools::Rake::Rubocop.call(
      config_file: config.config_file
    )
  end
end
