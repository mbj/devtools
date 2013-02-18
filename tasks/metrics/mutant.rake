# encoding: utf-8

namespace :metrics do
  allowed_versions = %w(mri-1.9.3 rbx-1.9.3)

  begin
    require 'mutant' 
  rescue LoadError
  end

  mutant_present = defined?(Mutant)

  if allowed_versions.include?(Devtools.rvm) and mutant_present
    desc 'Run mutant'
    task :mutant => :coverage do
      project = Devtools.project
      config  = project.mutant
      status = Mutant::CLI.run(%W(-r ./spec/spec_helper.rb ::#{config.namespace} --rspec-dm2))
      if status.nonzero?
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
