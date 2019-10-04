class TutorGroupStudent < ActiveRecord::Base

	acts_as_paranoid

	belongs_to :student
	belongs_to :tutor_group
end
