require "./position.rb"
require './bullet.rb'
require './enemy.rb'
require './player.rb'
require "./invader.rb"
require "curses"

Curses.init_screen
Curses.resize(60, 60)
Curses.cbreak
Curses.noecho
Curses.curs_set(0)

InvaderGame = Invader.new

def key_thread
  Thread.new do
    loop do
      case Curses.getch
      when "z"
        position = InvaderGame.player.position
        InvaderGame.move_player(Position.new(position.x - 1, position.y))
      when "x"
        position = InvaderGame.player.position
        InvaderGame.move_player(Position.new(position.x + 1, position.y))
      when 's'
        InvaderGame.shot
      end
      break if InvaderGame.gameover?
    end
  end
end

def main_thread
  Thread.new do
    added = Time.now
    loop do
      if Time.now - added > 3
        InvaderGame.add_enemy
        added = Time.now
      end
      InvaderGame.move_enemies
      InvaderGame.move_bullet
      InvaderGame.render
      sleep 0.1
      break if InvaderGame.gameover?
    end
  end
end

begin
  threads = []
  threads << key_thread
  threads << main_thread
  threads.each(&:join)
  Curses.close_screen
rescue Interrupt
  Curses.close_screen
end
