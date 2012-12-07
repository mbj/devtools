namespace :metrics do
  desc "Run mutant"
  task :mutant do
    project = Devtools.project
    config  = project.mutant
    cmd = %[bundle exec mutant -I lib -r #{config.name} "::#{config.namespace}" --rspec-dm2]
    Kernel.system(cmd)
  end
end
