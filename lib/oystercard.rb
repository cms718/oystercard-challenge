require 'journey'
class Oystercard

  attr_reader :balance, :entry_station, :exit_station, :journeys

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  def initialize(journey = Journey.new)
    @balance = 0
    @journeys = []
    @journey = journey
  end

  def top_up(amount)
    fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if (balance + amount) > MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in(station)
    fail "Insufficent balance" if balance < MINIMUM_BALANCE
    @journey.start(station)
  end

  def touch_out(station)
    deduct(MINIMUM_BALANCE)
    store_journey(station)
  end

  private

  def deduct(fare)
      @balance -= fare
  end

  def store_journey(station)
    @journeys << @journey.finish(station)
  end

end