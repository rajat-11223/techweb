class SlotSchedule < ActiveRecord::Base

	belongs_to :slot
	belongs_to :term
	belongs_to :master_day
	belongs_to :subject, -> {with_deleted}
	belongs_to :sub_subject, -> {with_deleted}
	belongs_to :user, -> {with_deleted}

	has_many :slot_schedule_students
	has_many :students, through: :slot_schedule_students

	belongs_to :learning_group, -> {with_deleted}
	belongs_to :tutor_group, -> {with_deleted}

end
