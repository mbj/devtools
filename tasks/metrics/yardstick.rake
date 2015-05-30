# encoding: utf-8

namespace :metrics do
  namespace :yardstick do
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

    options = Devtools.project.yardstick.options

    Yardstick::Rake::Measurement.new(:measure, options)

    Yardstick::Rake::Verify.new(:verify, options)
  end
end
