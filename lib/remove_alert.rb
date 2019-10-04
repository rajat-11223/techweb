module RemoveAlert

  def remove_alert_item(type, object_id, object_type, target_id, target_type)

  	@global_academic_session_id = AcademicSession.find_by(is_current: true).id
    @global_current_term_id = Term.where("academic_session_id = ? AND start_date < ?", @global_academic_session_id, Time.now).order(:master_term_id).last.id
	 	

    if type == "New Learning Objective"

    	student = Student.find(object_id)
	 	if student.student_learning_objectives.where(is_completed: false, is_closed:false).count > 2
	 		Alert.where(alert_type: type, object_entity_id: object_id).delete_all
	 	end
      
    elsif type == "Learning Objective Inactivity"

    	lo = StudentLearningObjective.find(target_id)
    	Alert.where(alert_type: type, target_entity_id: target_id).delete_all

    elsif type == "Schedule Conflict"

    	@conflict = SlotScheduleStudent.find_by_sql ["SELECT * FROM slot_schedule_students WHERE student_id = ? AND term_id = ? GROUP BY term_id, master_day_id, slot_id, student_id having COUNT(*) > 1;", object_id, @global_current_term_id]
    	if @conflict.blank?
    		Alert.where(alert_type: type, object_entity_id: object_id).delete_all
    	end
      
    elsif type == "Unscheduled Time"

      	# figure later if required

    else
      #ERROR
    end

  end

end