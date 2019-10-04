class ReportSubjectObservation < ActiveRecord::Base
	 acts_as_paranoid
	belongs_to :report_subject
	has_one :report,through: :report_subject
	has_many :report_subject_observation_evidences
	belongs_to :student_learning_objective_observation, -> {with_deleted}
	belongs_to :sub_subject, -> {with_deleted}
	belongs_to :subject, -> {with_deleted}
	belongs_to :user, -> {with_deleted}

end
