class Slot < Range
	def initialize(start)
		super(start, start + 30.minutes, true)
	end

	def in_opening?(opening)
		opening.cover?(self.begin) && opening.cover?(self.end)
	end

	def in_appointment?(appointment)
		(self.end > appointment.begin) && (self.begin < appointment.end)
	end

	def to_s
		self.begin.strftime('%-k:%M')  # Convert to H:MM format
	end
end