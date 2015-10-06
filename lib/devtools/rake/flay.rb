module Devtools
  module Rake
    # :reek:IrresponsibleModule
    class Flay
      include Anima.new(:threshold, :total_score, :files), Procto.call(:verify)

      # disable :reek:UtilityFunction
      def initialize(options)
        config = options.dup
        directories = config.delete(:directories)
        super(config.merge(files: ::Flay.expand_dirs_to_files(directories)))
      end

      # rubocop:disable AbcSize, MethodLength, GuardClause
      # disable :reek:DuplicateMethodCall :reek:TooManyStatements
      def verify
        # Run flay first to ensure the max mass matches the threshold
        masses = Devtools::Flay::Scale.call(minimum_mass: 0, files: files)

        max = masses.max.to_i
        unless max >= threshold
          Devtools.notify_metric_violation "Adjust flay threshold down to #{max}"
        end

        total = masses.inject(:+).to_i
        unless total.equal?(total_score)
          Devtools.notify_metric_violation "Flay total is now #{total}, but expected #{total_score}"
        end

        # Run flay a second time with the threshold set
        scale = Devtools::Flay::Scale.new(minimum_mass: threshold.succ, files: files)
        mass_size = scale.measure.size

        if mass_size.nonzero?
          scale.flay_report
          Devtools.notify_metric_violation "#{mass_size} chunks have a duplicate mass > #{threshold}"
        end
      end
    end
  end
end
