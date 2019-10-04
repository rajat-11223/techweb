class AnnualClosureController < ApplicationController


	def index

	end

	def annual_closure

		check_status
		# create_academic_sessions_and_terms
		# create_annual_grades
		# create_slots
		# promote_students_to_next_grade

		respond_to do |format|

			if @proceed
				create_academic_sessions_and_terms
				create_annual_grades
				create_slots
		# ----
				# check terms impact - all ok
				# check phases impact - all ok
				# check student leaning objectives impact
		# -----
		promote_students_to_next_grade
		continue_learning_groups_to_next_grade
		continue_tutor_groups_to_next_grade
		
		do_systemwide_sign_out
		format.html {redirect_to :back, alert: @notice}
	else
				# issue, cannot proceed
				format.html {redirect_to :back, alert: @notice}
			end

		end
		
	end

	def check_status

		# check the current term dates, blah blah etc for conditions to be met before starting a new year
		current_session = AcademicSession.find(session[:global_academic_session])
		terms_for_this_session = current_session.terms
		
		if !terms_for_this_session.blank?
			if terms_for_this_session.last.end_date <= Date.today # last term has already ended, good to go for any further conditional checking
				@proceed = true
			else # last term is stil in progress, prompt user and disallow
				@proceed = false
				@notice = "The last term of current session has not yet ended. This action cannot be performed right now."
			end 
		else
			# some data inconsistency
			@proceed = false
			@notice = "This action cannot be performed right now. Please contact support."

		end
	end
	

	def create_academic_sessions_and_terms

		current_session = AcademicSession.find(session[:global_academic_session])
		next_session = AcademicSession.where(id: session[:global_academic_session].to_i + 1)
		to_be_current_session = ""

		if !next_session.blank?
			to_be_current_session = AcademicSession.find(session[:global_academic_session].to_i + 1)
			to_be_current_session.is_current = true
			current_session.is_current = false
		else
			to_be_current_session = AcademicSession.new
			to_be_current_session.name = current_session.name.split("-").map{|x| x.to_i}.map{|x| x+1}.join("-")
			to_be_current_session.is_current = true
			current_session.is_current = false
		end

		to_be_current_session.save!
		current_session.save!
		
      	# Set global session
      	session[:global_academic_session] = AcademicSession.find_by(is_current: true).id

      	# Terms create
      	if Term.where(academic_session_id: session[:global_academic_session]).blank?

      		last_terms = Term.where(academic_session_id: AcademicSession.where("id < ?", AcademicSession.find(session[:global_academic_session])).last.id)

      		MasterTerm.all.each do |mt|
      			term = Term.find_or_initialize_by(academic_session_id: session[:global_academic_session], master_term_id: mt.id)
      			term.start_date = !last_terms.where(master_term_id: mt.id).blank? ? last_terms.where(master_term_id: mt.id).first.start_date + 1.year : Date.today
      			term.end_date = !last_terms.where(master_term_id: mt.id).blank? ? last_terms.where(master_term_id: mt.id).first.end_date + 1.year : Date.today
      			term.save
      		end
      	end
      end
      
      def create_annual_grades

      	current_session = AcademicSession.find(session[:global_academic_session])		
      	MasterGrade.all.collect{|g| g.id}.collect{|ag| AnnualGrade.find_or_create_by(academic_session_id: current_session.id, master_grade_id: ag)}
      	
      end

      def create_slots

      	current_session = AcademicSession.find(session[:global_academic_session])
      	previous_session = AcademicSession.where(id: AcademicSession.where("id < ?", current_session.id).last).first
		# previous_session = AcademicSession.where(id: session[:global_academic_session].to_i - 1).first
		Slot.where(academic_session_id: previous_session.id).each do |old_slot|
			
			new_slot = Slot.new

			new_slot.academic_session_id = current_session.id
			new_slot.name = old_slot.name
			new_slot.start_time = old_slot.start_time
			new_slot.end_time = old_slot.end_time
			new_slot.is_taught_time = old_slot.is_taught_time
			
			new_slot.save
		end
		
	end

	def promote_students_to_next_grade

		# TBC
		# AnnualGrade.where(academic_session_id: session[:global_academic_session]).map(&:annual_grade_students).flatten.each do |student|
		# 	if Student.find(student.student_id) # student present and not deleted
		# 		AnnualGradeStudent.find_or_initialize_by(student_id: student.student_id, annual_grade_id: student.)
		# 	else

		# 	end
		# end

		last_annual_grades = AnnualGrade.where("academic_session_id = ?", AcademicSession.where("id < ?", AcademicSession.find(session[:global_academic_session])).last.id)
		last_annual_grades.each do |lag|
			last_ag_master_grade_id = lag.master_grade_id
			current_ag_master_grade_id = last_ag_master_grade_id + 1

			current_ag = AnnualGrade.find_by(academic_session_id: session[:global_academic_session], master_grade_id: current_ag_master_grade_id)
			if current_ag
				students = lag.annual_grade_students.joins(:student)
				if !students.blank?
					students.each do |stud|
						ags = AnnualGradeStudent.find_or_initialize_by(student_id: stud.student_id, annual_grade_id: current_ag.id)
						ags.is_pfc = stud.is_pfc
						ags.save
					end
				end
			else # this case occurs when we go over the max school grade possible. TBC what action to perform

			end
		end
		
	end	

	def continue_learning_groups_to_next_grade

		# low priority
		# create a copy of existing LG to next grade
		# get all students onto the same group in next grade
		
	end	

	def continue_tutor_groups_to_next_grade

		# low priority
		# create a copy of existing TG to next grade
		# get all students onto the same group in next grade

		
	end

	def do_systemwide_sign_out

		sql = 'TRUNCATE sessions;'
		ActiveRecord::Base.connection.execute(sql)

	end


end
