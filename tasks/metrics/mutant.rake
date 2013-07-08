# encoding: utf-8

namespace :metrics do
  allowed_versions = %w(mri-1.9.3 mri-2.0.0 rbx-1.9.3)

  enabled = begin
    require 'mutant'
  rescue LoadError
    false
  end

  config    = Devtools.project.mutant
  enabled &&= config.enabled? && allowed_versions.include?(Devtools.rvm)

  zombify = %w(
    adamantium equalizer ice_nine infecto anima concord abstract_type
    descendants_tracker parser rspec unparser mutant
  ).include?(config.name)

  if enabled && !ENV['DEVTOOLS_SELF']
    desc 'Run mutant'
    task mutant: :coverage do
      namespace =
        if zombify
          Mutant::Zombifier.zombify
          Zombie::Mutant
        else
          Mutant
        end

      status = namespace::CLI.run(["::#{config.namespace}*", config.strategy])
      if status.nonzero?
        abort 'Mutant task is not successful'
      end
    end
  else
    desc 'Run Mutant'
    task mutant: :coverage do
      $stderr.puts 'Mutant is disabled'
    end
  end
end
