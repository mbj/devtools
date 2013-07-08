# encoding: utf-8

namespace :metrics do
  namespace :yardstick do
    begin
      require 'yardstick/rake/measurement'
      require 'yardstick/rake/verify'

      # Enable the legacy parser for JRuby until ripper is fully supported
      if Devtools.jruby?
        # Remove when https://github.com/lsegal/yard/issues/681 is resolved
        # This code first requires ripper, then removes the constant so
        # that it does not trigger a bug in YARD where if it checks if Ripper
        # is available and assumes other constants are defined, when JRuby's
        # implementation does not yet.
        require 'ripper'
        Object.send(:remove_const, :Ripper)
        YARD::Parser::SourceParser.parser_type = :ruby18
      end

      # yardstick_measure task
      Yardstick::Rake::Measurement.new(:measure)

      # verify_measurements task
      Yardstick::Rake::Verify.new(:verify) do |verify|
        config = Devtools.project.yardstick
        verify.threshold = config.threshold
      end
    rescue LoadError
      %w[ measure verify ].each do |name|
        task name.to_s do
          $stderr.puts "In order to run #{name}, do: gem install yardstick"
        end
      end
    end
  end
end
