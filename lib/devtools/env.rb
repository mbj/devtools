module Devtools
  # Detect ci
  #
  # @return [Boolean]
  #
  # @api private
  #
  def self.ci?
    ENV.key?('CI')
  end

  # Detect circle ci
  #
  # @return [Boolean]
  #
  # @api private
  #
  def self.circle_ci?
    ENV.key?('CIRCLECI')
  end
  
  # Detect travis ci
  #
  # @return [Boolean]
  #
  # @api private
  #
  def self.travis?
    ENV.key?('TRAVIS')
  end
end