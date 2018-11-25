namespace :metrics do
  desc 'Check with code style guide'
  task :rubocop do
    Devtools::Rake::Rubocop.call(
      config: Devtools.project.rubocop,
      directory: '.'
    )
  end
end
