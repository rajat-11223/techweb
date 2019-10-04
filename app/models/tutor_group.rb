class TutorGroup < ActiveRecord::Base

	acts_as_paranoid
	
	belongs_to :user, -> {with_deleted}
	belongs_to :academic_session

	has_many :tutor_group_students
	has_many :students, through: :tutor_group_students

	accepts_nested_attributes_for :tutor_group_students, :allow_destroy => true

end
