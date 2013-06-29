# encoding: utf-8

namespace :metrics do
  namespace :yardstick do
    begin
      require 'yardstick/rake/measurement'
      require 'yardstick/rake/verify'

      # Enable the legacy parser for JRuby until ripper is fully supported
      if Devtools.jruby?
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
          $stderr.puts "Yardstick is not available. In order to run #{name}, you must: gem install yardstick"
        end
      end
    end
  end
end
