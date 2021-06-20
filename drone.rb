require_relative 'gyroscope'
require_relative 'orientation_sensor'
require_relative 'engine'

class Drone
  attr_reader :status

  STATUSES = %i[off hovering moving].freeze

  def initialize
    @status = :off
    @gyroscope = Gyroscope.new
    @orientation_sensor = OrientationSensor.new
    @engines = Array.new(4.times.map { Engine.new })
  end

  STATUSES.each do |status|
    define_method "set_#{status}" do
      @status = status
    end
  end
end
