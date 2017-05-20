Position = Struct.new('Position', :x, :y) do
  def in_range?
    0 <= x && x < 10 && 0 <= y && y < 11
  end
end
