class StudentLearningObjective < ActiveRecord::Base

	acts_as_paranoid

	belongs_to :student
	belongs_to :user, -> {with_deleted}
	belongs_to :academic_session
	belongs_to :term
	# belongs_to :subject
	belongs_to :sub_subject, -> {with_deleted}
	has_one :report_objective
	has_many :focus_classes, class_name:  "StudentLearningObjectiveFocusSubject"
	has_many :targets, class_name:  "StudentLearningObjectiveTarget"
	has_many :observations, class_name:  "StudentLearningObjectiveObservation"
	has_many :achievements, class_name:  "StudentLearningObjectiveAchievement"

	belongs_to :global_lo, polymorphic: true

	def show_subject

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

	def show_p_level
		if self.p_level.blank?
			return "-"
		elsif self.p_sublevel.blank?
			return self.p_level.split(" ").join 
		else
			return self.p_level.split(" ").join  + " " + self.p_sublevel
		end
	end

	def show_focus_classes(academic_session)
		if self.focus_classes.blank?
			return nil
		else
 			self.focus_classes.where(academic_session_id: academic_session_id).map(&:sub_subject).collect {|x| x.show_name}.join(", ")
		end

	end		

	def show_focus_classes2(academic_session_id, term_id)
		if self.focus_classes.blank?
			return nil
		else
 			self.focus_classes.where(academic_session_id: academic_session_id, term_id: term_id).map(&:sub_subject).collect {|x| x.show_name}.join(", ")
		end

	end	

	def show_focus_classes3(academic_session_id, term_id, user_id)
		if self.focus_classes.blank?
			return nil
		else
 			self.focus_classes.where(academic_session_id: academic_session_id, term_id: term_id, user_id: user_id).map(&:sub_subject).collect {|x| x.show_name}.join(", ")
		end

	end



	def target_lower_bound(axis_id)
		!self.targets.find_by(master_csd_axis_id: axis_id).blank? ? self.targets.find_by(master_csd_axis_id: axis_id).baseline_value : 0

	end

	def target_upper_bound(axis_id)
		!self.targets.find_by(master_csd_axis_id: axis_id).blank? 	? self.targets.find_by(master_csd_axis_id: axis_id).target_value : 0

	end

	def achievement_value(axis_id)
		if !self.achievements.where(master_csd_axis_id: axis_id).blank? 
			self.achievements.where(master_csd_axis_id: axis_id).last.achievement_value
		else
			# return self.targets.find_by(master_csd_axis_id: axis_id).baseline_value
			return 0
		end
	end	

	
end
