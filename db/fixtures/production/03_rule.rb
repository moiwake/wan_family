Spot.first(10).each_with_index do |spot, i|
  RuleOption.first(10).each_with_index do |opt, j|
    Rule.seed do |s|
      s.id = j + 1 + (RuleOption.count * i)
      s.spot_id = spot.id
      s.rule_option_id = opt.id
      s.answer = ["0", "1"].sample
    end
  end
end
