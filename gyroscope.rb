class Gyroscope
  attr_accessor :x_velocity, :y_velocity, :z_velocity

  def initialize
    reset
  end

  def reset
    @x_velocity = 0
    @y_velocity = 0
    @z_velocity = 0
  end
end
