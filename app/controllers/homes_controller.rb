class HomesController < ApplicationController
  # before_action :set_current_view, only: [:index]
  # before_action :set_home, only: [:show, :edit, :update, :destroy]

  # GET /homes
  # GET /homes.json
  def index  

    if params[:view]

      case params[:view]

      when "all" 

        @students = Student.all.order("fname ASC")

      when "by_tutor_group"

        @students = current_user.tg_students.where("tutor_group_students.academic_session_id=?",session[:global_academic_session]).order("fname ASC")

      when "by_phase"

        if current_user.is_team_lead? && current_user.lead_phase_id(session[:global_academic_session]) != 0

          @students = current_user.phases.where("academic_session_id = ?", session[:global_academic_session]).last.students

        end

      when "by_class"

        # uniq_subjects = current_user.slot_schedules.where(academic_session_id: session[:global_academic_session]).pluck(:sub_subject_id).uniq
        
        # @all_uniq_subjects = current_user.slot_schedules.where(academic_session_id: session[:global_academic_session]).pluck(:sub_subject_id, :term_id).uniq
        
        # TODO Using hack tutor group not 0 OR learning group not 0 to exclude PPA - working   
        # @all_uniq_subjects = current_user.slot_schedules.where("academic_session_id = ? AND tutor_group_id != 0 OR learning_group_id != 0)", session[:global_academic_session]).pluck(:sub_subject_id, :term_id).uniq
        
        temp_exempt_subjects = Subject.where("subjects.is_lunch = true OR subjects.is_tutorial = true OR subjects.is_ppa = true").joins(:sub_subjects).pluck("sub_subjects.id")
        # @uniq_subjects = current_user.slot_schedules.where("academic_session_id = ? AND sub_subject_id NOT IN (select sub_subject.id from sub_subjects INNER JOIN subjects ON subjects.id = sub_subjects.subject_id WHERE subjects.is_lunch = true OR subjects.is_tutorial = true OR subjects.is_ppa = true;)", session[:global_academic_session], temp_exempt_subjects.join(',').gsub("'", "")).pluck(:sub_subject_id, :term_id, :learning_group_id).uniq
        @uniq_subjects = current_user.slot_schedules.order(term_id: :desc).where("academic_session_id = ? AND sub_subject_id NOT IN (select sub_subjects.id from sub_subjects INNER JOIN subjects ON subjects.id = sub_subjects.subject_id WHERE subjects.is_lunch = true OR subjects.is_tutorial = true OR subjects.is_ppa = true)", session[:global_academic_session]).pluck(:sub_subject_id, :term_id, :learning_group_id).uniq

        # terms = Term.where(academic_session_id: session[:global_academic_session]).pluck(:id)

        # @exempt_subjects = []

        # terms.each do |term|
        #   temp_exempt_subjects.each do |sub|
        #     @exempt_subjects << [sub,term]
        #   end
        # end

        # @uniq_subjects = @all_uniq_subjects - @exempt_subjects
        # @uniq_subjects = @uniq_subjects - @exempt_subjects
        # @user_subjects = uniq_subjects.collect {|sub| SubSubject.find(sub[0])}

      when "realm"

        # other view with timeline

        populate_students        

      else

        #Misconfig

      end

    else

      # current view with timeline

      populate_students

    end

      # @slots = Slot.where(academic_session_id: @selected_academic_session_id, is_taught_time: true)

  end

  def populate_students
    if !@timeline_selected_slot.blank? # a slot has been selected, either by user or because it matches with current time
      timeline_selected_schedule = @timeline_selected_slot.slot_schedules.find_by(academic_session_id: @timeline_selected_academic_session_id, term_id: @timeline_selected_term_id, master_day_id: @timeline_selected_master_day_id, user_id: current_user.id)

      if !timeline_selected_schedule.blank? # the schedule has been created in system, means it will be of schedulable subjects
        @students = timeline_selected_schedule.slot_schedule_students.map(&:student).compact.sort_by{|s| s[:fname]} #compacted to remove nil after mapping of deleted students

      else # the schedule is not created and is inferred
        
        if @timeline_selected_slot.is_scheduled_time # scheduleable slot but empty
          @students = nil
        
        elsif @timeline_selected_slot.is_taught_time # tutorial slot 

          if !current_user.get_tutor_group(@timeline_selected_academic_session_id).blank? # no tutor group       

            @students = current_user.get_tutor_group(@timeline_selected_academic_session_id).students.with_deleted.order("fname ASC")        
          else # no tutor group        
            # @students = current_user.get_tutor_group(@timeline_selected_academic_session_id).students        
          end
        
        else # show students in all classes of this teacher
          @students = current_user.slot_schedules.where(academic_session_id: @timeline_selected_academic_session_id).joins(:students).pluck(:student_id).uniq.collect{ |s| Student.find(s) }.sort_by{|s| s[:fname]}
        end
      
      end

    else # no slot has been selected because it may be outside school hours
      @students = current_user.slot_schedules.where(academic_session_id: @timeline_selected_academic_session_id).joins(:students).pluck(:student_id).uniq.collect{ |s| Student.find(s) }.sort_by{|s| s[:fname]}
    end

  end

  # GET /homes/1
  # GET /homes/1.json
  def show
  end

  # GET /homes/new
  def new
    @home = Home.new
  end

  # GET /homes/1/edit
  def edit
  end

  # POST /homes
  # POST /homes.json
  def create
    # @home = Home.new(home_params)

    # respond_to do |format|
    #   if @home.save
    #     format.html { redirect_to @home, notice: 'Home was successfully created.' }
    #     format.json { render :show, status: :created, location: @home }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @home.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /homes/1
  # PATCH/PUT /homes/1.json
  def update
    # respond_to do |format|
    #   if @home.update(home_params)
    #     format.html { redirect_to @home, notice: 'Home was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @home }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @home.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /homes/1
  # DELETE /homes/1.json
  def destroy
    # @home.destroy
    # respond_to do |format|
    #   format.html { redirect_to homes_url, notice: 'Home was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_home
  # @home = Home.find(params[:id])
  end    

  # Never trust parameters from the scary internet, only allow the white list through.
  def home_params
    params[:home]
  end


end
