def tick(args)
  prep(args) if args.tick_count.zero?
  $game.args = args
  $game.tick()
end
