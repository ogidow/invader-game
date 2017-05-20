class Enemy
  attr_accessor :position, :moved, :previos_position
  def initialize
    @moved_at = Time.now
    @position = Position.new(rand(0..9), 0)
    @previos_position = nil
    @moved = true
  end

  def movable?(boost)
    (Time.now - @moved_at) >= (3 - boost)
  end

  def next_position
    next_position = if [:x, :y].sample == :x
                      Position.new(@position.x + [1, -1].sample, @position.y)
                    else
                      Position.new(@position.x, @position.y + 1)
                    end

    [@position, next_position]
  end

  def move!(position)
    @previos_position = @position
    @position = position
    @moved_at = Time.now
  end

  def moved
    @moved
  end

  def to_s
    "*"
  end
end
