Spot.all.each do |spot|
  RuleOption.all.each do |opt|
    Rule.seed do |s|
      s.id = Rule.count + 1
      s.spot_id = spot.id
      s.rule_option_id = opt.id
      s.answer = ["0", "1"].sample
    end
  end
end
