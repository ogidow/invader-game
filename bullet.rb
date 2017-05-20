class Bullet
  attr_accessor :position, :moved, :previos_position
  def initialize(position)
    @moved_at = Time.now
    @position = position
    @previos_position = nil
    @moved = true
  end

  def movable?
    (Time.now - @moved_at) >= 1
  end

  def move!
    @previos_position = @position
    @position = Position.new(@position.x, @position.y - 1)
    @moved_at = Time.now
  end

  def moved
    @moved
  end

  def to_s
    "|"
  end
end
