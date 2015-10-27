namespace :metrics do
  namespace :yardstick do
    require 'yardstick/rake/measurement'
    require 'yardstick/rake/verify'

    options = Devtools.project.yardstick.options

    Yardstick::Rake::Measurement.new(:measure, options)

    Yardstick::Rake::Verify.new(:verify, options)
  end
end
