class StudentLearningObjectiveObservation < ActiveRecord::Base

	acts_as_paranoid

	belongs_to :student_learning_objective
	belongs_to :user, -> {with_deleted}
	belongs_to :subject, -> {with_deleted}
	belongs_to :sub_subject, -> {with_deleted}
		# has_many :evidences, class_name:  "StudentLearningObjectiveObservationFile"

	has_many :student_learning_objective_observation_files
	accepts_nested_attributes_for :student_learning_objective_observation_files,:allow_destroy=>true, :reject_if => proc { |att| att[:evidence].blank? }
	belongs_to :student

	has_one :report_objective_observation
	has_one :report_subject_observation

	# has_many :summary_original_objectives, class_name: "SummaryLearningObjective", foreign_key: :original_obs_id
	# has_many :summary_learning_objectives, class_name: "SummaryLearningObjective", foreign_key: :summary_obs_id

	has_many :original_observation_files, class_name: "StudentLearningObjectiveObservationFile", foreign_key: :original_obs_id
	has_many :summary_achievements, class_name:  "SummaryLearningObjectiveAchievement"
	
	# custom methods
	# def show_evidence(size)

	# 	self.student_learning_objective_observation_file.url(size)

	# end
	# end
	
	def summary_achievement_value(axis_id)
		
		if !self.summary_achievements.where(master_csd_axis_id: axis_id).blank? 
			self.summary_achievements.where(master_csd_axis_id: axis_id).last.achievement_value
		else
			return 0
		end
		
	end
end
