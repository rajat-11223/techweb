class SubSubject < ActiveRecord::Base

	acts_as_paranoid
	belongs_to :subject, -> {with_deleted}
	has_many :slot_schedules, -> {with_deleted}

	has_many :student_learning_objective_focus_subjects
	has_many :student_learning_objectives, through: :student_learning_objective_focus_subjects
	has_many :student_learning_objective_observations
	has_many :reports_objectives
	has_one :report_core_subject
		has_many :report_subjects

	
	def show_name
		if self.is_none == true
			return self.subject.name
		else
			return self.subject.name + ": " + self.name
		end
	end

	def show_focus_learning_objectives(academic_session)
		self.student_learning_objectives.where(academic_session_id: academic_session)
	end

end
