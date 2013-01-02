# encoding: utf-8

namespace :metrics do
  allowed_versions = %w(mri-1.9.3 rbx-1.9.3)

  if allowed_versions.include?(Devtools.rvm)
    desc 'Run mutant'
    task :mutant => :coverage do
      project = Devtools.project
      config  = project.mutant
      cmd = %[bundle exec mutant -r ./spec/spec_helper.rb "::#{config.namespace}" --rspec-dm2]
      Kernel.system(cmd) || raise('Mutant task is not successful')
    end
  else
    desc 'Run Mutant'
    task :mutant => :coverage do
      $stderr.puts "Mutant is disabled under ruby vms other than #{allowed_versions.join(', ')}"
    end
  end
end
