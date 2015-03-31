require 'slot'

class DayRange < Range

	def initialize(day_start)
		super(day_start, day_start.next_day, true)
	end

	def to_availability(openings, appointments)
		{ date: self.begin, slots: available_slots(openings, appointments) } 
	end

	private

	def available_slots(openings, appointments)
		all_slots                                                   # retrieve all slot of the day
			.select{ |slot| in_openings?(openings, slot) }          # select slots that are contained within an opening event
			.reject{ |slot| in_appointments?(appointments, slot) }  # reject slots that intersect an appointment
			.map   { |slot| slot.to_s }                             # Convert to H:MM format
	end

	# returns all slots of the DayRange (with a given interval)
	# either work as iterator or enumerator wether a block is provided
	def all_slots(interval=30.minutes, &block)
		return to_enum(:all_slots, interval) unless block_given?
		time = self.begin
    	while time < self.end
      		yield Slot.new(time)
      		time += interval
      	end
    end

	def in_openings?(openings, slot)
		openings.any?{ |opening| slot.in_opening?(opening) }
	end

	def in_appointments?(appointments, slot)
		appointments.any?{ |appointment| slot.in_appointment?(appointment) }
	end
end