class Subject < ActiveRecord::Base

	acts_as_paranoid
	has_many :sub_subjects
	accepts_nested_attributes_for  :sub_subjects,:allow_destroy=>true, :reject_if => proc { |att| att[:name].blank? }
	has_one :report_core_subject
	has_many :report_subjects
	# has_many :student_learning_objective_focus_subjects
	# has_many :student_learning_objectives, through: :student_learning_objective_focus_subjects
	
	# def show_focus_learning_objectives(academic_session)
	# 	self.student_learning_objectives.where(academic_session_id: academic_session)
	# end
	
end
