class ReportSubjectObservationEvidence < ActiveRecord::Base
	belongs_to :report_subject_observation
	belongs_to :student_learning_objective_observation_file, -> {with_deleted}
end
