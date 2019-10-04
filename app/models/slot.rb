class Slot < ActiveRecord::Base

	belongs_to :academic_session

	has_many :slot_schedules
	
end
