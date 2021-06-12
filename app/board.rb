class Board
  class << self
    def default_map()
      return { "0": false, "1": true }
    end

    def default_colors()
      return { true => [255, 255, 255, 255], false => [0, 0, 0, 255] }
    end

    def gen_empty_board(w: 8, h: 8)
      return Array.new(h) { Array.new(w) { false } } 
    end

    def decode_string_to_bool_arr(w: 8, h: 8, strings: [""], map: default_map())
      yi = 0
      o = gen_empty_board(w: w, h: h)
      while yi < h
        xi = 0
        while xi < w
          o[yi][xi] = (map[strings[yi][xi].to_sym] || false)
          xi += 1
        end
        yi += 1
      end

      return o
    end
  end

  def default_map()
    return self.class.default_map()
  end

  def default_colors()
    return self.class.default_colors()
  end

  def gen_empty_board(w: 8, h: 8)
    return self.class.gen_empty_board(w: w, h: h)
  end

  def decode_string_to_bool_arr(w: 8, h: 8, string: "", map: default_map())
    return self.class.decode_string_to_bool_arr(w: w, h: h, strings: string, map: map)
  end

  def initialize(x: 0, y: 0, tw: 16, th: 16, w: 8, h: 8, colors: default_colors(), decode_str: nil, map: default_map())
    if decode_str
      @board = decode_string_to_bool_arr(w: w, h: h, string: decode_str, map: map)
    else
      @board = gen_empty_board(w: w, h: h)
    end
    @x = x
    @y = y
    @tw = tw
    @th = th
    @w = w
    @h = h
    @colors = colors
  end

  def step!()

  end

  def draw_override(ffi_draw)
    db = @board.reverse()

    yi = 0
    while yi < @h
      xi = 0
      while xi < @w
        # x,y,w,h,r,g,b,a
        ffi_draw.draw_solid(xi * @tw + @x, yi * @th + @y, @tw, @th, *@colors[db[yi][xi]])
        xi += 1
      end
      yi += 1
    end
  end

  def count_neighbours(x, y)
    count = 0

    ym = -2
    while !(ym==1)
      xm = -2
      ym += 1
      yi = y + ym
      next if yi < 0 || yi >= @h
      while !(xm==1)
        xm += 1
        xi = x + xm
        next if xi < 0 || xi >= @w

        count += 1 if @board[yi][xi]
      end
    end

    return count - (@board[y][x] ? 1 : 0)
  end

  def step!()
    built = gen_empty_board(w: @w, h: @h)

    # i = 0 
    # while i < @w * @h
    #   count = count_neighbours(i % @w, i.div(@h))
    #   cell = @board[i]

    #   built[i] = cell && (count == 2 || count == 3) || !cell && count == 3
    #   i += 1
    # end

    yi = 0
    while yi < @h
      xi = 0
      while xi < @w
        count = count_neighbours(xi, yi)

        built[yi][xi] = (@board[yi][xi] && count == 2) || count == 3

        xi += 1
      end
      yi += 1
    end

    @board = built
  end
end
