require_relative 'gyroscope'
require_relative 'orientation_sensor'
require_relative 'engine'

class Drone
  attr_reader :status

  HIGH_POWER = 100
  STABLE_POWER = 75
  LANDING_POWER = 50
  LOW_POWER = 25

  STATUSES = %i[off hovering moving].freeze

  MOVEMENT_ENGINE_MAPPING = {
    forward: { faster: [2, 3], slower: [0, 1] },
    left: { faster: [1, 3], slower: [0, 2] },
    right: { faster: [0, 2], slower: [1, 3] },
    back: { faster: [0, 1], slower: [2, 3] },
    up: { faster: [0, 1, 2, 3], slower: [] },
    down: { faster: [], slower: [0, 1, 2, 3] }
  }.freeze

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

  MOVEMENT_ENGINE_MAPPING.each do |movement, engines_hash|
    define_method "move_#{movement}" do |high_power: HIGH_POWER, low_power: LOW_POWER|
      set_engines_power(engines_hash[:faster], high_power)
      set_engines_power(engines_hash[:slower], low_power)
      set_velocities_and_orientation(movement)
    end
  end

  def take_off
    move_up
  end

  def stabilize
    set_engines_power([0, 1, 2, 3], STABLE_POWER)
    reset_gyroscope_and_orientation
  end

  def land
    move_down(low_power: LANDING_POWER)
  end

  private

  def set_engines_power(engines_arr, power)
    engines_arr.each do |index|
      engine = @engines[index]
      return false unless engine.set_power(power)
    end
    true
  end

  def set_velocities_and_orientation(movement)
    # set velocities

    # set orientation
  end

  def reset_gyroscope_and_orientation
    # reset gyroscope
    @gyroscope.x_velocity = 0
    @gyroscope.y_velocity = 0
    @gyroscope.z_velocity = 0

    # reset orientation
    @orientation_sensor.x_direction = nil
    @orientation_sensor.y_direction = nil
  end

  def send_distress_signal
    puts 'Distress Signal'
  end
end
