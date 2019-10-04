module SendAlert

	@queue = :send_alert_queue

	 def self.perform

	 	@global_academic_session_id = AcademicSession.find_by(is_current: true).id
      	@global_current_term_id = Term.where("academic_session_id = ? AND start_date < ?", @global_academic_session_id, Time.now).order(:master_term_id).last.id

	 	@alerts = Alert.where("is_email = true AND created_at > ?", 24.hours.ago)

	 	@alerts.each do |alert| 

	 		# Send EMail
	 		# student = Student.find(object_entity_id)
	 		# tutor = student.get_tutor_group(@global_academic_session_id)
	 		if alert.alert_type == "Learning Objective Inactivity"
			 			
					AlertMailer.lo_inactivity(alert.object_entity_id, alert.target_entity_id, @global_current_term_id).deliver_later

	 		elsif alert.alert_type == "New Focus Needed"

					AlertMailer.new_focus_needed(alert.object_entity_id, alert.target_entity_id, @global_current_term_id).deliver_later

	 		end
	 	end
	 end



end