module Devtools
  module Rake
    # :reek:IrresponsibleModule
    class Flay
      include Anima.new(:threshold, :total_score, :files), Procto.call(:verify), Adamantium

      # disable :reek:UtilityFunction
      def initialize(options)
        config = options.dup
        directories = config.delete(:directories)
        super(config.merge(files: ::Flay.expand_dirs_to_files(directories)))
      end

      # rubocop:disable MethodLength, GuardClause
      # disable :reek:DuplicateMethodCall :reek:TooManyStatements
      def verify
        # Run flay first to ensure the max mass matches the threshold
        if threshold > largest_mass
          Devtools.notify_metric_violation "Adjust flay threshold down to #{largest_mass}"
        end

        unless total_mass.equal?(total_score)
          Devtools.notify_metric_violation "Flay total is now #{total_mass}, but expected #{total_score}"
        end

        # Run flay a second time with the threshold set
        mass_size = restricted_flay_scale.measure.size

        if mass_size.nonzero?
          restricted_flay_scale.flay_report
          Devtools.notify_metric_violation "#{mass_size} chunks have a duplicate mass > #{threshold}"
        end
      end

    private

      def total_mass
        flay_masses.reduce(:+).to_i
      end

      def largest_mass
        flay_masses.max.to_i
      end

      def restricted_flay_scale
        Devtools::Flay::Scale.new(minimum_mass: threshold.succ, files: files)
      end
      memoize :restricted_flay_scale

      def flay_masses
        Devtools::Flay::Scale.call(minimum_mass: 0, files: files)
      end
      memoize :flay_masses
    end
  end
end
