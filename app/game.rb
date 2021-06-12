$gtk.reset

class Game
  attr_gtk

  def prep()
    $a = [
      "011000000000",
      "001000000000",
      "010000000000",
      "011000000011",
      "000100001001",
      "011001100110",
      "100100001000",
      "110000000110",
      "000000000010",
      "000000000100",
      "000000000110"
    ]
    @board = Board.new(th: 32, tw: 32, w: 12, h: 11, decode_str: $a)
  end
  
  def tick()
    outputs.solids << @board 
    @board.step!() if args.tick_count < 8

    args.outputs.screenshots << [0,0,32*12,32*11,"ss/t_%03d.png" % args.tick_count, [256]*4] if args.tick_count < 8
  end
end
