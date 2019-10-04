class SlotScheduleStudent < ActiveRecord::Base

	belongs_to :slot_schedule
	belongs_to :student, -> {with_deleted}

	belongs_to :associated_group, polymorphic: true

end
