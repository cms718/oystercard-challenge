require 'station'
class Journey
  PENALTY_FARE = 6
  attr_reader :entry_station, :exit_station

  def initialize(entry_station = nil)
    @entry_station = entry_station
    @in_progress = true
    @exit_station = nil
  end

  def complete?
    !@in_progress
  end
  
  def start(entry_station)
    @entry_station = entry_station
  end
  
  def finish(exit_station)
    @exit_station = exit_station
    @in_progress = false if @entry_station
    self
  end

  def fare
    @in_progress ? PENALTY_FARE : 1
  end
end 