class StudentLearningObjectiveAchievement < ActiveRecord::Base

	belongs_to :student_learning_objective
	belongs_to :student_learning_objective_observation
	belongs_to :master_csd_axis

end
