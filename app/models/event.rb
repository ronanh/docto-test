require 'day_range'

class Event < ActiveRecord::Base
  scope :openings_starting_before,     ->(time) { where({kind: 'opening'    }, "starts_at < ?", time) }
  scope :appointments_starting_before, ->(time) { where({kind: 'appointment'}, "starts_at < ?", time) }

  def self.availabilities(start, nb_days = 7)
    (start..start+(nb_days-1).day)
      .map { |day| DayRange.new(day) }
      .map { |day_range| day_range.to_availability(openings_of_the_day(day_range), appointments_of_the_day(day_range)) }
  end

  # convert to a time range ensuring to return something within the provided range 
  # it will try to use recurrence to find a matching range
  # returns nil upon failure to find such a matching range
  def to_range_within(range)
    nb_weeks_offset = self.weekly_recurring ? ((range.end - self.starts_at.to_datetime) / 7).to_i : 0
    r = Range.new(self.starts_at + nb_weeks_offset.week, self.ends_at + nb_weeks_offset.week)
    range.cover?(r.begin)&&range.cover?(r.end) ? r : nil
  end

  private

  def self.openings_of_the_day(day_range)
    openings_starting_before(day_range.end)
      .map { |event| event.to_range_within(day_range) }  # map to a range within the given day or nil (takes into account recurrence)
      .compact
  end

  def self.appointments_of_the_day(day_range)
    appointments_starting_before(day_range.end)
      .map{ |event| event.to_range_within(day_range) }  # map to a range within the given day or nil (takes into account recurrence)
      .compact
  end

end