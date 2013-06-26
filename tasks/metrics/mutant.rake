# encoding: utf-8

namespace :metrics do
  allowed_versions = %w(mri-1.9.3 mri-2.0.0 rbx-1.9.3)

  begin
    require 'mutant'
  rescue LoadError
  end

  config  = Devtools.project.mutant
  enabled = defined?(Mutant) && config.enabled?

  if allowed_versions.include?(Devtools.rvm) && enabled && !ENV['DEVTOOLS_SELF']
    desc 'Run mutant'
    task :mutant => :coverage do
      status = Mutant::CLI.run(%W(::#{config.namespace}* #{config.strategy}))
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
