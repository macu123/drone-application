class OrientationSensor
  attr_accessor :x_direction, :y_direction

  def reset
    @x_direction = nil
    @y_direction = nil
  end
end
