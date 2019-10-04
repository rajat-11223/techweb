module StudentAlert

	@queue = :student_alert_queue

	 def self.perform

	 	@global_academic_session_id = AcademicSession.find_by(is_current: true).id
      	@global_current_term_id = Term.where("academic_session_id = ? AND start_date < ?", @global_academic_session_id, Time.now).order(:master_term_id).last.id
	 	
	 	# Delete all previously auto-generated alerts from table
	 	Alert.where("created_at < ? AND is_manual = false", Time.now).delete_all

	 	# New Learning Objective : The student has fewer than 3 Learning Objectives assigned.

	 	@students = Student.all
	 	@students.each do |student|
	 		if student.student_learning_objectives.where(is_completed: false, is_closed:false).count < 3
	 			# Populate Alert Here
	 			@alert = Alert.new
	 			@alert.generate_new("New Learning Objective", student.id, student.class.name, nil, nil)
	 		end
	 	end
	 	
	 	# Learning Objective Inactivity : Collect all open learning objectives and see if the objective has not had an observation in last 3 weeks/ 21 days
	 	elapsed_threshold = 21.days.ago
	 	@learning_objectives = StudentLearningObjective.all.where(is_completed: false, is_closed: false, temp_complete: false)
	 	@learning_objectives.each do |lo|
	 		if !lo.observations.blank? 
	 			if lo.observations.last.created_at < elapsed_threshold
		 			# create the alert as per student id
		 			@alert = Alert.new
		 			@alert.generate_new("Learning Objective Inactivity", lo.student.id, lo.student.class.name, lo.id, lo.class.name)
	 			end
	 		else
	 			if lo.assigned_date < elapsed_threshold
	 				@alert = Alert.new
		 			@alert.generate_new("Learning Objective Inactivity", lo.student.id, lo.student.class.name, lo.id, lo.class.name)
		 		end
	 		end
	 	end
	 	


	 	# Schedule Conflict : The student is assigned to two class slots at the same time.
	 	
	 	@conflicts = SlotScheduleStudent.find_by_sql ["SELECT * FROM slot_schedule_students WHERE term_id = ? GROUP BY term_id, master_day_id, slot_id, student_id having COUNT(*) > 1;", @global_current_term_id]
	 	@conflicts.each do |conflict|
	 		# NOT REQUIRED to go into detail. SlotScheduleStudent.where(term_id: conflict.term_id, master_day_id: conflict.master_day_id, slot_id: conflict.slot_id, student_id: conflict.student_id)
	 		# create the alert as per student id
	 		@alert = Alert.new
	 		@alert.generate_new("Schedule Conflict", conflict.student_id, "Student", nil, nil)
	 	
	 	end


	 	# Unscheduled Time : check if the student is not assigned to any class for one of their slots and the term begins in less than 1 week.

	 	upcoming_term = Term.where("academic_session_id = ? AND start_date > ?", @global_academic_session_id, Time.now).order(:master_term_id).first
	 	if !upcoming_term.blank? && upcoming_term.start_date < 7.days.from_now
		 	
		 	@students = Student.all
	      	@master_days = MasterDay.all
	      	@slots = Slot.where(academic_session_id: @global_academic_session_id, is_scheduled_time: true)

		 	@students.each do |student|
		 		catch :empty_slot do
			 		@master_days.each do |day|
			 			@slots.each do |slot|
			 			 	if student.slot_schedules.find_by(slot_id: slot.id, term_id: upcoming_term.id, master_day_id: day.id).blank?
			 			 		#Populate unscheduled class alert here for this id
		 						@alert = Alert.new
	 							@alert.generate_new("Unscheduled Time", student.id, student.class.name, nil, nil)
		 						throw :empty_slot

			 			 	end
			 			end
			 		end
		 		end # control comes here if empty_slot is caught, effectively ending loop and creating entry only once for one student
		 	end
		end

		# New Focus Needed : 

		# find all scheduled classes of students and then check for them to have atleast one focus LO. If the subject has no focus LO, send mail to subject teacher

	 	@students = Student.all
	 	@students.each do |student|

	 		learning_objectives = student.student_learning_objectives
	 		focus_subjects_array = learning_objectives.joins(:focus_classes).where("student_learning_objective_focus_subjects.term_id = ?",@global_current_term_id).pluck("student_learning_objective_focus_subjects.sub_subject_id").uniq
	 		scheduled_classes_array = student.slot_schedules.where(term_id: @global_current_term_id).pluck(:sub_subject_id).uniq

	 		non_focus_subjects = scheduled_classes_array - focus_subjects_array
	 		non_focus_subjects.each do |nf|
	 			@alert = Alert.new
	 			@alert.generate_new("New Focus Needed", student.id, student.class.name, nf.to_i, "SubSubject")
	 		end


	 	end

	 end

end