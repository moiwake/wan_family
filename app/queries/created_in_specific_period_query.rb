class CreatedInSpecificPeriodQuery
  attr_reader :scope, :date, :number

  def initialize(scope:, date:, number:)
    @scope = scope
    @date = date
    @number = number
  end

  def self.call(scope:, date:, number:)
    @scope = new(scope: scope, date: date, number: number).for_specific_period
    @scope
  end

  def for_specific_period
    to = Time.current + 1
    from = (to - number.send(date)).at_beginning_of_day
    scope.where(created_at: from...to)
  end
end
