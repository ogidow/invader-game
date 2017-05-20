class Invader
  attr_accessor :field, :player

  def initialize()
    @field = Array.new(10) { Array.new(10, nil) }
    @enemies = []
    @bullets = []
    @player = Player.new
    @score = 0
    initialize_screen
  end

  def add_enemy
    @enemies << Enemy.new
  end

  def move_enemies
    boost = @score / 500.0
    @enemies.each do |enemy|
      next unless enemy.movable?(boost)
      current_position, next_position = enemy.next_position
      if next_position.in_range? && @field[next_position.x][next_position.y].nil?
        @field[next_position.x][next_position.y] = enemy
        @field[current_position.x][current_position.y] = nil
        enemy.move!(next_position)
      end
    end
  end

  def move_bullet
    @bullets.each do |bullet|
      next unless bullet.movable?
      if bullet.position.y == 0
        @field[bullet.position.x][bullet.position.y] = nil
        @bullets.reject! {|target| target == bullet }
        set_blank(bullet.position.x, bullet.position.y)
        next
      end

      if !@field[bullet.position.x][bullet.position.y - 1].nil?
        enemy = @field[bullet.position.x][bullet.position.y - 1]
        @enemies.reject! {|target| target == enemy }
        @bullets.reject! {|target| target == bullet }

        @field[bullet.position.x][bullet.position.y] = nil
        @field[enemy.position.x][enemy.position.y] = nil
        set_blank(bullet.position.x, bullet.position.y)
        set_blank(enemy.position.x, enemy.position.y)
        @score += 10
      else
        bullet.move!
        @field[bullet.position.x][bullet.position.y] = bullet
        @field[bullet.position.x][bullet.position.y + 1] = nil
      end
    end
  end

  def move_player(position)
    return unless position.in_range?
    @field[@player.position.x][@player.position.y] = nil
    @field[position.x][position.y] = @player
    @player.move!(position)

  end

  def gameover?
    @enemies.any? {|enemy| enemy.position.y == 9 }
  end

  def render
    [@player, @enemies, @bullets].flatten.each do |obj|

      next unless obj.moved
      previos_position = obj.previos_position
      current_position = obj.position
      set_blank(previos_position.x, previos_position.y) unless previos_position.nil?
      Curses.setpos(current_position.y, current_position.x)
      Curses.addstr(obj.to_s)
    end
    Curses.setpos(5, 50)
    Curses.addstr("Score: #{@score}")
    Curses.refresh
  end

  def shot
    position = Position.new(@player.position.x, @player.position.y - 1)
    @bullets << Bullet.new(position)
  end

  def initialize_screen
    (0..9).each do |x|
      (0..9).each do |y|
        set_blank(x, y)
      end
    end
  end

  def set_blank(x, y)
    Curses.setpos(y, x)
    Curses.addstr(' ')
  end
end
