class ReportObjective < ActiveRecord::Base
		belongs_to :report
		has_many :report_objective_evidences
		# has_many :report_achievements, class_name:  "ReportObservationAchievement"
		has_many :report_observation_achievements
		belongs_to :sub_subject, -> {with_deleted}
		belongs_to :student_learning_objective, -> {with_deleted}
		# has_many :report_observations, class_name:  "ReportObjectiveObservation"
		# has_many :report_evidences, class_name:  "ReportObservationEvidence", through: :report_observations	
		has_many :report_objective_observations
		has_many :report_observation_evidences, through: :report_objective_observations

		REPORT_STATUS = Report::REPORT_STATUS

	def achievement_value(axis_id)
		if !self.report_achievements.where(master_csd_axis_id: axis_id).blank? 
			self.reports_achievements.where(master_csd_axis_id: axis_id).last.achievement_value
		else
			return 0
		end
	end

	def report_show_subject

		if self.sub_subject.blank?
			return "-"
		else
			if self.sub_subject.is_none
				return self.sub_subject.subject.name
			else
				return self.sub_subject.subject.name + ":" + self.sub_subject.name
			end
		end
	end

	def report_show_p_level
		if self.p_level.blank?
			return "-"
		elsif self.p_sublevel.blank?
			return self.p_level.split(" ").join 
		else
			return self.p_level.split(" ").join  + " " + self.p_sublevel
		end
	end

	def report_achievement_value(axis_id)
		if !self.report_observation_achievements.where(master_csd_axis_id: axis_id).blank? 
			self.report_observation_achievements.where(master_csd_axis_id: axis_id).last.achievement_value
		else
			return 0
		end
	end	


	def translate_lo_status
		if self.lo_status.nil? || self.lo_status == REPORT_STATUS[0][1]
			response_val = nil
		elsif self.lo_status == REPORT_STATUS[1][1]
			response_val = ["To Be Reviewed","red"]
		elsif self.lo_status == REPORT_STATUS[2][1]
			response_val = ["Achieved","green"]
		end

		return response_val

	end

end
