class ReportObjectiveEvidence < ActiveRecord::Base
	belongs_to :report_objective
		belongs_to :student_learning_objective_observation_file

end
