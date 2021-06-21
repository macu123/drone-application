require_relative 'gyroscope'
require_relative 'orientation_sensor'
require_relative 'engine'

class Drone
  attr_reader :status

  NUMS_OF_ENGINES = 4

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
    @engines = Array.new(NUMS_OF_ENGINES.times.map { Engine.new })
  end

  MOVEMENT_ENGINE_MAPPING.each do |movement, engines_hash|
    define_method "move_#{movement}" do |high_power: HIGH_POWER, low_power: LOW_POWER|
      return false unless high_power && low_power && (high_power > low_power)
      return false if (@status == :off) && (movement != :up)

      # one is engine break when trying to take off, the other is engine break while in the air
      if any_engine_break? && (@status == :off)
        send_distress_signal
        return
      elsif any_engine_break? && (movement != :down)
        send_distress_signal
        land
        return
      end

      set_engines_power(engines_hash[:faster], high_power)
      set_engines_power(engines_hash[:slower], low_power)
      reset_gyroscope_and_orientation
      set_gyroscope_and_orientation(movement)
      set_moving

      # for testing purpose
      puts orientations
      puts velocities
      puts "status: #{status}"
    end
  end

  def take_off
    move_up
  end

  def stabilize
    set_engines_power([0, 1, 2, 3], STABLE_POWER)
    reset_gyroscope_and_orientation
    set_hovering
  end

  # assume both drone and engines are off when landed
  def land
    move_down(low_power: LANDING_POWER)
    reset_gyroscope_and_orientation
    @engines.collect(&:turn_off)
    set_off
  end

  def tap
    stabilize
  end

  def turn_on_engines
    @engines.collect(&:turn_on)
  end

  def orientations
    {
      x_direction: @orientation_sensor.x_direction,
      y_direction: @orientation_sensor.y_direction
    }
  end

  def velocities
    {
      x_velocity: @gyroscope.x_velocity,
      y_velocity: @gyroscope.y_velocity,
      z_velocity: @gyroscope.z_velocity
    }
  end

  def engines_status
    @engines.map { |engine| engine.is_on? ? 'On' : 'Off' }
  end

  private

  STATUSES.each do |status|
    define_method "set_#{status}" do
      @status = status
    end
  end

  def set_engines_power(engines_arr, power)
    engines_arr.each do |index|
      engine = @engines[index]
      engine.set_power(power)
    end
  end

  # for simplicity, we assume velocity and power are the same
  def set_gyroscope_and_orientation(movement)
    mapping_hash = MOVEMENT_ENGINE_MAPPING[movement]
    case movement
    when :forward
      @gyroscope.y_velocity = sum_of_engines_power(mapping_hash[:faster]) - sum_of_engines_power(mapping_hash[:slower])
      @orientation_sensor.y_direction = movement
    when :back
      @gyroscope.y_velocity = sum_of_engines_power(mapping_hash[:slower]) - sum_of_engines_power(mapping_hash[:faster])
      @orientation_sensor.y_direction = movement
    when :left
      @gyroscope.x_velocity = sum_of_engines_power(mapping_hash[:slower]) - sum_of_engines_power(mapping_hash[:faster])
      @orientation_sensor.x_direction = movement
    when :right
      @gyroscope.x_velocity = sum_of_engines_power(mapping_hash[:faster]) - sum_of_engines_power(mapping_hash[:slower])
      @orientation_sensor.x_direction = movement
    when :up
      @gyroscope.z_velocity = sum_of_engines_power(mapping_hash[:faster]) - sum_of_engines_power_for_stable
    when :down
      @gyroscope.z_velocity = sum_of_engines_power(mapping_hash[:slower]) - sum_of_engines_power_for_stable
    end
  end

  def sum_of_engines_power(engines_pos_arr)
    engines_pos_arr.reduce(0) { |sum, engine_pos| sum + @engines[engine_pos].power }
  end

  def sum_of_engines_power_for_stable
    STABLE_POWER * NUMS_OF_ENGINES
  end

  def any_engine_break?
    @engines.any?(&:is_off?)
  end

  def reset_gyroscope_and_orientation
    @gyroscope.reset
    @orientation_sensor.reset
  end

  def send_distress_signal
    puts 'Distress Signal'
  end
end
