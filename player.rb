class Player
  attr_accessor :position, :moved, :previos_position
  def initialize
    @moved_at = Time.now
    @position = Position.new(rand(0..9), 9)
    @previos_position = nil
    @moved = true
  end

  def movable?
    (Time.now - @moved_at) >= 1
  end

  def move!(position)
    @previos_position = @position
    @position = position
    @moved_at = Time.now
  end

  def to_s
    "A"
  end
end
