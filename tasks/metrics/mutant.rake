# encoding: utf-8

namespace :metrics do
  allowed_versions = %w(mri-1.9.3 rbx-1.9.3)

  require 'mutant' rescue LoadError

  mutant_present = defined?(Mutant)

  if allowed_versions.include?(Devtools.rvm) and mutant_present
    desc 'Run mutant'
    task :mutant => :coverage do
      project = Devtools.project
      config  = project.mutant
      successful = Mutant::Cli.run(%W(mutant -r ./spec/spec_helper.rb "::#{config.namespace}" --rspec-dm2))
      unless successful
        raise 'Mutant task is not successful'
      end
    end
  else
    desc 'Run Mutant'
    task :mutant => :coverage do
      $stderr.puts 'Mutant is disabled'
    end
  end
end
