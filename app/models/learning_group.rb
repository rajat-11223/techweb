class LearningGroup < ActiveRecord::Base

	acts_as_paranoid

	belongs_to :user
	has_many :learning_group_students
	has_many :students ,through: :learning_group_students

	has_many :slot_schedule_students, as: :associated_group

	accepts_nested_attributes_for :learning_group_students, :allow_destroy => true


# custom methods


# end




end