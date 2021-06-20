class Engine
  attr_reader :power

  STATUSES = %i[off on].freeze

  def initialize
    turn_off
  end

  STATUSES.each do |status|
    define_method "turn_#{status}" do
      @power = 0
      @status = status
    end

    define_method "is_#{status}?" do
      @status == status
    end
  end

  def set_power(power)
    return false if is_off?
    return false unless (power >= 0) && (power <= 100)

    @power = power
    true
  end
end
