module ReportAlert
	@queue = :report_alert_queue

		def self.perform(student_id,rs_id,recipient,subject,desc,action_name,current_user)
			if action_name == "save_request_amend"
				AlertMailer.report_request_amend(student_id,rs_id,recipient,subject,desc,action_name,current_user).deliver_later
			elsif action_name == "save_reminder"
				AlertMailer.report_send_reminder(student_id,rs_id,recipient,subject,desc,action_name,current_user).deliver_later
			elsif action_name == "admin_send_reminder"
				AlertMailer.admin_send_reminder(student_id,rs_id,recipient,subject,desc,action_name,current_user).deliver_later
			elsif action_name == "send_for_approval"
				AlertMailer.report_send_for_approval(student_id,rs_id,recipient,subject,desc,action_name,current_user).deliver_later
			elsif action_name == "approve_report"
				AlertMailer.report_approve(student_id,rs_id,recipient,subject,desc,action_name,current_user).deliver_later
			elsif action_name == "send_back_unapproved"
				AlertMailer.report_unapprove(student_id,rs_id,recipient,subject,desc,action_name,current_user).deliver_later
		    elsif action_name == "send_report_parents"		
		    	AlertMailer.send_report_parent(student_id,rs_id,recipient,subject,desc,action_name,current_user).deliver_later
			end	

		end
	end