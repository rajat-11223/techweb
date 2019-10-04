class ReportPolicy < ApplicationPolicy

	def editable_report_check?(academic_session, student_id, report)
		# if admin_check? 
		# 	return true
		# else
			if team_lead_check?	&& report.status != "AP"
				return true
			elsif tutor_check?(academic_session, student_id) && report.status != "AP" && report.status != "AA"
				return true
			else
				return false
			end
		# end

    end	

    def editable_summary_check?(student_id, report, sub_subject_id)
		# if admin_check? 
		# 	return true
		# else
			if team_lead_check?	&& report.status != "AP"
				return true
			# elsif tutor_check?(report.academic_session_id, student_id) && report.status != "AP" && report.status != "AA"
			# 	return true
			elsif subject_teacher_check?(report.academic_session_id, student_id, sub_subject_id) && report.status != "AP" && report.status != "AA"
				return true
			else 
				return false
			end
		# end

    end


  #   def editable_all_check?(student_id, report, sub_subject_id, academic_session)
		# # if admin_check? 
		# # 	return true
		# # else
		# 	if team_lead_check?	&& report.status != "AP"
		# 		return true
		# 	elsif tutor_check?(report.academic_session_id, student_id) && report.status != "AP" && report.status != "AA"
		# 		return true
		# 	elsif subject_teacher_check?(report.academic_session_id, student_id, sub_subject_id) && report.status != "AP" && report.status != "AA"
		# 		return true
		# 	else 
		# 		return false
		# 	end
		# # end

  #   end

    def tutor_check?(academic_session, student_id)
    	current_user.is_student_tutor?(academic_session, student_id)
    end

    def admin_check?
    	current_user.is_admin?
    end

    def team_lead_check?
    	current_user.is_team_lead?
    end

    def subject_teacher_check?(academic_session, student_id, sub_subject_id)
    	if Student.with_deleted.find(student_id).slot_schedules.where(academic_session_id: academic_session, sub_subject_id: sub_subject_id, user_id: current_user.id).present?
    		return true
    	else
    		return false
    	end
    end

end
