require 'email_alert'
require 'remove_alert'

class ApplicationController < ActionController::Base
# before_filter :retrive_csd
	include RemoveAlert
	include Pundit

	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.

	# before_action :save_extra_params, if: :devise_controller?
	protect_from_forgery with: :exception
	before_filter :authenticate_user!
	before_filter :populate_timeline

	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

	# def save_extra_params
	# 	devise_parameter_sanitizer.for(:sign_up) << [:email, :password, :password_confirmation, :fname, :lname, :isd_code, :home_phone, :mobile_phone, :description, :avatar]
	# 	devise_parameter_sanitizer.for(:sign_in) << [:email, :password]
	# end
	# def retrive_csd
		
# @master_csd_axis = Rails.cache.fetch("master_csd_axis") do 
#   MasterCsdAxis.all
# end
	# end
	def after_sign_in_path_for(resource)

		populate_system	
	
		# session[:user_return_to] || session[:previous_url] || homes_path
		 homes_path
	
	end

	def populate_system

		session[:global_academic_session] = AcademicSession.find_by(is_current: true).id		
		
		current_term = Term.where("academic_session_id = ? AND start_date <= ? AND end_date >= ?", session[:global_academic_session], Time.now, Time.now).order(:master_term_id).last
		
		if !current_term.blank?
			session[:global_current_term] = current_term.id
		else
			if !Term.where("academic_session_id = ? AND start_date <= ?", session[:global_academic_session], Time.now).order(:master_term_id).blank? # middle of two terms in an available session
				session[:global_current_term] = Term.where("academic_session_id = ? AND start_date <= ?", session[:global_academic_session], Time.now).order(:master_term_id).last.id
			else # middle of academic years after annual closure
				session[:global_current_term] = Term.where("academic_session_id = ?", session[:global_academic_session]).order(:master_term_id).first.id
			end
		end

	end

	def populate_timeline

		if user_signed_in?

			@timeline_selected_moment = (params[:realm_date].present? ? params[:realm_date].to_time : Time.now)

			@timeline_selected_master_day_id = @timeline_selected_moment.wday

			@timeline_selected_academic_session_id = session[:global_academic_session] # previous day functionality is applicable only for this current session

			@ay_start_date = Term.where("academic_session_id = ?", @timeline_selected_academic_session_id).order(:master_term_id).first.start_date
			@ay_end_date = Term.where("academic_session_id = ?", @timeline_selected_academic_session_id).order(:master_term_id).last.end_date

			if !Term.where("academic_session_id = ? AND start_date <= ?", @timeline_selected_academic_session_id, @timeline_selected_moment.to_date).blank? # middle of two terms in an available session
				@timeline_selected_term_id = Term.where("academic_session_id = ? AND start_date <= ?", @timeline_selected_academic_session_id, @timeline_selected_moment.to_date).order(:master_term_id).last.id
			else # middle of academic years after annual closure
				@timeline_selected_term_id  = Term.where("academic_session_id = ?", @timeline_selected_academic_session_id).order(:master_term_id).first.id
			end

			# @timeline_selected_term_id = Term.where("academic_session_id = ? AND start_date <= ?", @timeline_selected_academic_session_id, @timeline_selected_moment.to_date).order(:master_term_id).last.id

			@timeline_slots = Slot.where(academic_session_id: @timeline_selected_academic_session_id)

			timeline_slot_array = @timeline_slots.collect{|s| [s.id, s.start_time.strftime('%H:%M:%S'), s.end_time.strftime('%H:%M:%S')]}

			if params[:realm_slot].present?

				timeline_selected_slot_id = params[:realm_slot]

			else

				only_current_time = Time.now.localtime.strftime('%H:%M:%S')

				if only_current_time < timeline_slot_array.first[1].to_time.strftime('%H:%M:%S') || only_current_time > timeline_slot_array.last[2].to_time.strftime('%H:%M:%S')

					timeline_selected_slot_id = 0

				else        
					
					timeline_selected_slot_id = timeline_slot_array.find{|s| (s[1] < Time.now.localtime.strftime('%H:%M:%S') && s[2] > Time.now.localtime.strftime('%H:%M:%S'))}.first

				end

			end

			@timeline_selected_slot = (timeline_selected_slot_id.to_i != 0 ? Slot.find(timeline_selected_slot_id.to_i) : nil)

		end

	end

	def autocomplete


		@results=[]

	    @staff = User.order(:fname).where("fname LIKE ? OR lname LIKE ?", "%#{params[:term]}%", "%#{params[:term]}%")
	    @students = Student.order(:fname).where("fname LIKE ? OR lname LIKE ?", "%#{params[:term]}%", "%#{params[:term]}%")
	    
	    @results = @staff + @students
	     
	    respond_to do |format|
	      format.html
	      format.json  { render :json => @results.to_json}
	    end

	end

	def change_timeline_state
		current_user.timeline_minimized = params[:timeline_state]
		current_user.save

		render nothing: true
		
	end

	private

	def user_not_authorized
		flash[:alert] = "You are not authorized to perform this action."
		redirect_to(request.referrer || homes_path)
	end

end
