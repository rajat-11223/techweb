class AlertMailer < ApplicationMailer

	def temp_complete_lo(student_lo,current_session_id)

		@student_lo=StudentLearningObjective.find(student_lo)
		@student=Student.find(@student_lo.student_id)
		@student_tutor=@student.tutor_groups.find_by(academic_session_id: current_session_id).user
		
		subject=@student.name + " has achieved the Learning Objective " + @student_lo.title
		recipient =@student_tutor.email
		from = User.find(@student_lo.temp_complete_user_id).email
		mail(from: from, to: recipient,subject: subject )
	end

	def temp_decline_learning_objective(student_lo,current_session_id)
		@student_lo=StudentLearningObjective.find(student_lo)
		@student=Student.find(@student_lo.student_id)
		@student_tutor=@student.tutor_groups.find_by(academic_session_id: current_session_id).user
		subject=@student.name + "'s Learning Objective " + @student_lo.title

		from = @student_tutor.email
		recipient = User.find(@student_lo.temp_complete_user_id).email
		mail(from: from, to: recipient,subject: subject )

		
	end

def close_lo_learning_objective(lo,current_session_id,current_user_id,focus)
		
		@lo=StudentLearningObjective.find(lo)
			@lo_student=@lo.student.name
			@current_user = User.find(current_user_id)
			@focus=StudentLearningObjectiveFocusSubject.find(focus)
			from=@current_user.email
			subject=@lo_student + "'s Learning Objective " + @lo.title	
			recipient = @focus.user.email
		mail(from: from, to: recipient,subject: subject )	
end

	def lo_inactivity(student_id, lo_id, term_id)
		# @student_lo=StudentLearningObjective.find(student_lo)
		current_session_id = AcademicSession.find_by(is_current: true).id
		@student=Student.find(student_id)
		@learning_objective = StudentLearningObjective.find(lo_id)

		student_tutor = @student.tutor_groups.find_by(academic_session_id: current_session_id).user
		
		@recipient_id_array = @learning_objective.focus_classes.where(academic_session_id: current_session_id, term_id: term_id).pluck(:user_id)
		@recipient_id_array << student_tutor.id
		@recipient_id_array = @recipient_id_array.reverse.uniq

		subject= "#{@student.name}'s Learning Objective #{@learning_objective.title}"
		from = @student.annual_grades.last.phase.user.email
		recipient = @recipient_id_array.map{|u| User.find(u)}.collect{|u| u.email}.join(",")
		
		# mail(from: from, to: recipient, subject: subject)
		mail(to: recipient, subject: subject)

		
	end	

	def new_focus_needed(student_id, sub_subject_id, term_id)

		current_session_id = AcademicSession.find_by(is_current: true).id

		@student = Student.find(student_id)
		@subject = SubSubject.find(sub_subject_id)
		@nf_subject_teacher = @student.slot_schedules.find_by(term_id: term_id, sub_subject_id: sub_subject_id).user

		student_tutor = @student.tutor_groups.find_by(academic_session_id: current_session_id).user
		
		subject= "You need to select a new focus for #{@student.name}"
		from = student_tutor.email
		recipient = @nf_subject_teacher.email
		
		# mail(from: from, to: recipient, subject: subject)
		mail(to: recipient, subject: subject)

		
	end

	def report_request_amend(student_id,rs_id,recipient,subject,desc,action_name,current_user)
		@student = Student.find(student_id)
			@rs = ReportSubject.find(rs_id)
			@user = User.find(current_user)

		subject= subject
		from = @user.email
		recipient = recipient
		@desc = desc
		mail(from: from, to: recipient, subject: subject)


	end

	def report_send_reminder(student_id,rs_id,recipient,subject,desc,action_name,current_user)
		@student = Student.find(student_id)
		@rs = ReportSubject.find(rs_id)
		@user = User.find(current_user)

		subject= subject
		from = @user.email
		recipient = recipient
		@desc = desc
		mail(from: from, to: recipient, subject: subject)
	end

	def admin_send_reminder(student_id,rs_id,recipient,subject,desc,action_name,current_user)
		@student = Student.find(student_id)
		@rs = Report.find(rs_id)
		@user = User.find(current_user)

		subject= subject
		from = @user.email
		recipient = recipient
		@desc = desc
		mail(from: from, to: recipient, subject: subject)
	end



	def send_report_parent(student_id,rs_id,recipient,subject,desc,action_name,current_user)

		@student = Student.find(student_id)
		@rs = Report.find(rs_id)
		@user = User.find(current_user)
		subject= subject
		from = @user.email
		recipient = recipient
		@desc = desc
		mail(from: from, to: recipient, subject: subject)		
	end

	def report_send_for_approval(student_id,rs_id,recipient,subject,desc,action_name,current_user)
		@student = Student.find(student_id)
		@rs = Report.find(rs_id)
		@user = User.find(recipient)
		@current_user = User.find(current_user)
		subject= "#{@rs.title} for #{@student.fname} has been submitted for approval"
		from = @current_user.email
		recipient = @user.email
	
		mail(from: from, to: recipient, subject: subject)
	end	

def report_approve(student_id,rs_id,recipient,subject,desc,action_name,current_user)
		@student = Student.find(student_id)
		@rs = Report.find(rs_id)
		@user = User.find(recipient)
		@current_user = User.find(current_user)
		subject= "#{@rs.title} for #{@student.fname} has been approved"
		from = @current_user.email
		recipient = @user.email	
		mail(from: from, to: recipient, subject: subject)
	end	
	

	def report_unapprove(student_id,rs_id,recipient,subject,desc,action_name,current_user)
		@student = Student.find(student_id)
		@rs = Report.find(rs_id)
		@user = User.find(recipient)
		@current_user = User.find(current_user)
		@desc = desc
		
		subject= "#{@current_user.name} has requested amends for #{@student.fname}'s #{@rs.title}"
		from = @current_user.email
		recipient = @user.email
	
		mail(from: from, to: recipient, subject: subject)
	end
		
	end










