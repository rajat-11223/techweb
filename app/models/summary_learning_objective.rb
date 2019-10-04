class SummaryLearningObjective < ActiveRecord::Base

	belongs_to   :original_obs, class_name: "StudentLearningObjectiveObservation", foreign_key: "original_obs_id"
  	belongs_to   :summary_obs, class_name: "StudentLearningObjectiveObservation", foreign_key: "summary_obs_id"
end
