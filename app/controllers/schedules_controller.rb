class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:show, :edit, :destroy]

  # GET /schedules
  # GET /schedules.json
  def index
    # @schedules = Schedule.all
    @slot_schedule = SlotSchedule.new

    t_auth_sched = SlotSchedule.first
    if !t_auth_sched.blank?
      authorize t_auth_sched
    end


    # @subjects=Subject.where(is_core: false)
    @subjects=Subject.where(is_core: false, is_pivats: false, is_lunch: false, is_tutorial: false)

    if params[:schedule_display]

      @selected_academic_session = params[:schedule_display][:academic_session_id]
      @selected_master_term = params[:schedule_display][:master_term_id]
      @selected_tutor = params[:schedule_display][:tutor_id]

      @academic_sessions = AcademicSession.all.order("id DESC")
      @tutors = User.all.order("fname ASC")
      @master_terms = MasterTerm.all

      @master_days = MasterDay.all
      # @slots = Slot.where(academic_session_id: @selected_academic_session, is_scheduled_time: true)
      @slots = Slot.where(academic_session_id: @selected_academic_session, is_taught_time: true)

      @term = Term.find_by(master_term_id: @selected_master_term, academic_session_id: @selected_academic_session)

      # error for previous year's term if not present!
      @slot_schedules = SlotSchedule.where(term_id: @term.id, user_id: @selected_tutor)

      @has_schedule = true

    else
      @selected_academic_session = session[:global_academic_session]
      @selected_master_term = Term.find(session[:global_current_term]).master_term_id

      @academic_sessions = AcademicSession.all.order("id DESC")

      @tutors = User.all.order("fname ASC")
      @master_terms = MasterTerm.all
      @master_days = MasterDay.all

      @slots = Slot.where(academic_session_id: session[:global_academic_session], is_scheduled_time: true)

    end
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show
  end

  # GET /schedules/new
  def new
    @schedule = Schedule.new
  end

  # GET /schedules/1/edit
  def edit
  end

  # POST /schedules
  # POST /schedules.json
  def create
    @schedule_display = JSON.parse params[:schedule_display].to_s.gsub('=>', ':')
    @slot_schedule = SlotSchedule.new(slot_schedule_params)
    
    if !slot_schedule_params[:subject_id].present? # means it is a lunch, tutor group (not tutorial subject) or a PPA and will need to manually find subject id
      if params[:sub_subject_id][:subject_id].present?
        @slot_schedule.subject_id = SubSubject.find(params[:sub_subject_id][:subject_id]).subject
      end
    end

    if params[:sub_subject_id][:subject_id].present? # Save sub subject id here for all cases. not sure why is it in a if condition
      @slot_schedule.sub_subject_id=params[:sub_subject_id][:subject_id]
    end

    @slot_schedule.user_id=@schedule_display["tutor_id"] # save schedule's teacher

    if params[:learning_group].present? # save LG for curriculum classes
      @slot_schedule.learning_group_id=params[:learning_group]
    end

     if params[:tutor_group_id].present? # save TG for tutorial classes
      @slot_schedule.tutor_group_id=params[:tutor_group_id]
      end

    # if params[:tutor_group_id].present? # save TG for tutorial classes
    #   @slot_schedule.tutor_group_id=params[:tutor_group_id]

    # elsif (SubSubject.find(params[:sub_subject_id][:subject_id]).is_tutorial) # this elsif functionality is mostly useless but kept as a backup.

    #   @slot_schedule.tutor_group_id = User.find(@slot_schedule.user_id).get_tutor_group(session[:global_academic_session]).id
    # end


    @slot_schedule.academic_session_id = @schedule_display["academic_session_id"]
    respond_to do |format|
      if @slot_schedule.save
        if params[:students]

          @term = Term.find_by(master_term_id: @schedule_display["master_term_id"], academic_session_id: session[:global_academic_session])

          params[:students].each do |stud|
            @stud=Student.find(stud)
            @stud.temp_schedule_user_id=0
            @stud.save

            # check if students are assigned to any other class - NEED TO PUT NOTIFICATION MANUALLY HERE?
            # @stud.slot_schedule_students.slot_schedules.where(term_id: @term.id, master_day_id: @slot_schedule)

            # Check if the student is already assigned to a slot and then update it - NO LONGER DONE
            # @slot_students = SlotScheduleStudent.find_or_initialize_by(student_id: stud, term_id: @term.id, slot_id: @slot_schedule.slot_id, master_day_id: @slot_schedule.master_day_id)
            @slot_students = SlotScheduleStudent.find_or_initialize_by(student_id: stud, term_id: @term.id, slot_id: @slot_schedule.slot_id, master_day_id: @slot_schedule.master_day_id, slot_schedule_id: @slot_schedule.id)
            # @slot_students.slot_schedule_id = @slot_schedule.id

            # Find original learning group of student and check if it is the same as being assigned to class
            # @slot_students_original_lg_id = @stud.show_learning_group_id(session[:global_academic_session])

            # if @slot_students_original_lg_id == params[:learning_group].to_i
            #   @slot_students.associated_group_id = params[:learning_group]
            # else
            #   @slot_students.associated_group_id = 0
            # end

            if @slot_schedule.learning_group_id != 0
              @slot_students.associated_group_type = "LearningGroup"
              @slot_students.associated_group_id = @stud.show_learning_group_id(session[:global_academic_session])
            end

            if @slot_schedule.tutor_group_id != 0
              @slot_students.associated_group_type = "TutorGroup"
              @slot_students.associated_group_id = @stud.show_tutor_group_id(session[:global_academic_session])
            end

            @slot_students.save
          end
        end
        format.html { redirect_to schedules_path(:schedule_display=>@schedule_display), notice: 'Scheduled successfully.' }
        format.json { render :show, status: :created, location: @slot_schedule }
      else
        format.html { render :new }
        format.json { render json: @slot_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schedules/1
  # PATCH/PUT /schedules/1.json
  def update # TO COMPLETE

    @schedule_display = JSON.parse params[:schedule_display].to_s.gsub('=>', ':')

    @slot_schedule=SlotSchedule.find(params[:id])

    if params[:slot_schedule][:subject_id].blank? # means it is a lunch and will need to manually find subject id
      if params[:slot_schedule][:sub_subject_id].present?
        @slot_schedule.subject_id = SubSubject.find(params[:slot_schedule][:sub_subject_id]).subject.id
      else
        @slot_schedule.subject_id = SubSubject.find(params[:sub_subject_id][:subject_id]).subject.id
      end
    else
      @slot_schedule.subject_id=params[:slot_schedule][:subject_id]
    end


    if params[:slot_schedule][:sub_subject_id].present?
      @slot_schedule.sub_subject_id=params[:slot_schedule][:sub_subject_id]
    else
      @slot_schedule.sub_subject_id=params[:sub_subject_id][:subject_id]
    end

    if !params[:sub_subject_id].blank? && SubSubject.find(params[:sub_subject_id][:subject_id]).name=="PPA"

      @slot_schedule.slot_schedule_students.destroy_all

      @slot_schedule.tutor_group_id=0
      @slot_schedule.learning_group_id=0
      params[:students] = nil

    else

      if params[:learning_group]
        @slot_schedule.learning_group_id=params[:learning_group]
        @slot_schedule.tutor_group_id=0
      else
        @slot_schedule.tutor_group_id=params[:tutor_group_id]
        @slot_schedule.learning_group_id=0
      end
    end

    respond_to do |format|

      if @slot_schedule.save

        if params[:students]
          params[:students].each do |stud|
            @stud=Student.find(stud)
            @stud.temp_schedule_user_id=0
            @stud.save
          end
          updated_students = params[:students]
          existing_students = @slot_schedule.students.collect{|s| "#{s.id}"}
          new_students = updated_students - existing_students
          deleted_students = existing_students - updated_students
          
          new_students.each do |s|

            @student = Student.find(s.to_i)

            @slot_students_original_lg_id = @student.show_learning_group_id(session[:global_academic_session])
            @slot_students_original_tg_id = @student.show_tutor_group_id(session[:global_academic_session])

            @students_schedule = SlotScheduleStudent.new
            @students_schedule.slot_schedule_id=@slot_schedule.id
            @students_schedule.student_id=@student.id

            # @students_schedule.associated_group_id=@slot_students_original_lg_id
            # @students_schedule.associated_group_type="LearningGroup"

            @students_schedule.slot_id=@slot_schedule.slot_id

            if @slot_schedule.learning_group_id != 0
              @students_schedule.associated_group_type = "LearningGroup"
              @students_schedule.associated_group_id = @student.show_learning_group_id(session[:global_academic_session])
            end

            if @slot_schedule.tutor_group_id != 0
              @students_schedule.associated_group_type = "TutorGroup"
              @students_schedule.associated_group_id = @student.show_tutor_group_id(session[:global_academic_session])
            end

            @students_schedule.term_id=@slot_schedule.term_id
            @students_schedule.master_day_id=@slot_schedule.master_day_id
            

            @students_schedule.save


          end

          existing_students.each do |s|
            
            @student = Student.find(s.to_i)
            @slot_students_original_lg_id = @student.show_learning_group_id(session[:global_academic_session])
            @slot_students_original_tg_id = @student.show_tutor_group_id(session[:global_academic_session])

            @students_schedule = SlotScheduleStudent.find_by(slot_schedule_id: @slot_schedule.id, student_id: @student.id)


            if @slot_schedule.learning_group_id != 0
              @students_schedule.associated_group_type = "LearningGroup"
              @students_schedule.associated_group_id = @student.show_learning_group_id(session[:global_academic_session])
            end

            if @slot_schedule.tutor_group_id != 0
              @students_schedule.associated_group_type = "TutorGroup"
              @students_schedule.associated_group_id = @student.show_tutor_group_id(session[:global_academic_session])
            end
            
            @students_schedule.save

          end
            

          deleted_students.collect { |id| SlotScheduleStudent.where(slot_schedule_id: @slot_schedule.id, student_id: id).destroy_all}
        else

          SlotScheduleStudent.where(slot_schedule_id: @slot_schedule.id).destroy_all


        end


        format.html { redirect_to schedules_path(:schedule_display=>@schedule_display), notice: 'Scheduled successfuly.' }
        format.json { render :show, status: :ok, location: @schedule }
      else
        format.html { render :edit }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to schedules_url, notice: 'Schedule was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  #custom methods
  def open_create_schedule_modal
    @slot_schedule = SlotSchedule.new

    # @subjects=Subject.where(is_core: false, is_pivats: false, is_lunch: false, is_tutorial: false)
    @subjects=Subject.where(is_core: false, is_pivats: false)
    @slot=Slot.find_by(:id => params[:slot_id])
    @day=MasterDay.find_by(:id=>params[:day_id])


    @schedule_display = JSON.parse params[:schedule_display].to_s.gsub('=>', ':')
    @learning_groups = LearningGroup.where(academic_session_id: @schedule_display["academic_session_id"] )

    @term = Term.find_by(master_term_id: @schedule_display["master_term_id"].to_i, academic_session_id: @schedule_display["academic_session_id"].to_i)
    #for remove userid
    Student.where(temp_schedule_user_id: current_user.id).each do |stud|
      stud.temp_schedule_user_id=0
      stud.save
    end
    respond_to do |format|
      format.js {render '/schedules/js/open_create_schedule_modal'}
    end
  end

  def update_schedule_modal

    @phases=Phase.where(academic_session_id:  session[:global_academic_session])

    # @subjects=Subject.where(is_core: false, is_pivats: false, is_lunch: false, is_tutorial: false)
    @subjects=Subject.where(is_core: false, is_pivats: false)
    @schedule_display = JSON.parse params[:schedule_display].to_s.gsub('=>', ':')

    @slot=Slot.find(params[:slot_id])
    @master_day=MasterDay.find(params[:day_id])
    @term= Term.find(params[:term_id])

    @tutor_id = params[:tutor_id]

    #for remove user-id
    Student.where(temp_schedule_user_id: current_user.id).each do |stud|
      stud.temp_schedule_user_id=0
      stud.save
    end

    @learning_groups = LearningGroup.where(academic_session_id: @schedule_display["academic_session_id"] )
    @slot_schedule = SlotSchedule.find_by(slot_id: @slot.id, master_day_id: @master_day.id,term_id: @term.id,user_id: params[:tutor_id])

    @slot_schedule.students.each do |stud|
      stud.temp_schedule_user_id = current_user.id
      stud.save
    end

    if @slot_schedule.learning_group_id!=0

      @learning_group_students=Student.where(temp_schedule_user_id: current_user.id)
    else

      @tutor_group_students=Student.where(temp_schedule_user_id: current_user.id)
    end
    @sub_subjects=SubSubject.where(subject_id: @slot_schedule.subject_id)
    @tutor_groups = TutorGroup.where(:academic_session_id=> @schedule_display["academic_session_id"])




    respond_to do |format|
      format.js {render '/schedules/js/update_schedule_modal'}
    end
  end

  def update_schedule_subject_change

    @sub_subjects=SubSubject.where(:subject_id=>params[:subject_id])
    respond_to do |format|
      format.js {render '/schedules/js/update_schedule_subject_change'}
    end

  end
  def update_schedule_subsubject_change

    if params[:subid1].present?
      @sub_subject=SubSubject.find(params[:subid1])
    else
      @sub_subject=SubSubject.find(params[:subid2])
    end

    @learning_groups = LearningGroup.where(academic_session_id: params[:academic] )
    @tutor_group = TutorGroup.find_by(:user_id => params[:current_tutor],:academic_session_id=>session[:global_academic_session])
    if !@tutor_group.blank?
      @tutor_group_students = @tutor_group.students
    end
    respond_to do |format|
      if @sub_subject.is_tutorial
        format.js {render '/schedules/js/update_verify_sub_subject'}
      else
        format.js {render '/schedules/js/update_not_verify_sub_subject'}
      end
    end

  end
  # def remove_lg_student_update_schedule
  # end

  def update_schedule_lo

    @phases=Phase.where(academic_session_id:  session[:global_academic_session])

    @learning_group= LearningGroup.find(params[:learning_group_id])
    @learning_group_students= @learning_group.students
    #   Student.all.each do |student|
    #   student.temp_schedule_user_id=0
    #   student.save
    # end
    Student.where(temp_schedule_user_id: current_user.id).each do |stud|
      stud.temp_schedule_user_id=0
      stud.save
    end


    @learning_group_students.each do |stud|
      stud.temp_schedule_user_id=current_user.id
      stud.save
    end
    respond_to do |format|
      format.js {render '/schedules/js/update_schedule_lo'}
    end
  end


  def open_create_schedule_lunch_modal
    @slot_schedule = SlotSchedule.new

    @subjects=Subject.where(is_core: false, is_pivats: false, is_lunch: false, is_tutorial: false)
    @slot=Slot.find_by(:id => params[:slot_id])
    @day=MasterDay.find_by(:id=>params[:day_id])


    @schedule_display = JSON.parse params[:schedule_display].to_s.gsub('=>', ':')
    @learning_groups = LearningGroup.where(academic_session_id: @schedule_display["academic_session_id"] )

    #for remove student
    Student.where(temp_schedule_user_id: current_user.id).each do |stud|
      stud.temp_schedule_user_id=0
      stud.save
    end

    @term = Term.find_by(master_term_id: @schedule_display["master_term_id"].to_i, academic_session_id: @schedule_display["academic_session_id"].to_i)
    respond_to do |format|
      format.js {render '/schedules/js/open_create_schedule_lunch_modal'}
    end

  end


  def update_main_tutorial_schedule
    @slot_schedule = SlotSchedule.find_by(:slot_id=>params[:slot_id],:master_day_id=>params[:day_id],:term_id=>params[:term_id],:user_id=>params[:tutor_id])
    @slot=Slot.find_by(:id => params[:slot_id])
    @master_day=MasterDay.find_by(:id=>params[:day_id])
    @term= MasterTerm.find_by(:id=>params[:term_id])
    @schedule_display = JSON.parse params[:schedule_display].to_s.gsub('=>', ':')
    @tutor_groups = TutorGroup.where(academic_session_id: @schedule_display["academic_session_id"] )
    @tutor_id = params[:tutor_id]
    @term = Term.find_by(master_term_id: @schedule_display["master_term_id"].to_i, academic_session_id: @schedule_display["academic_session_id"].to_i)

    #for remove user-id
    Student.where(temp_schedule_user_id: current_user.id).each do |stud|
      stud.temp_schedule_user_id=0
      stud.save
    end

    respond_to do |format|

      format.js {render '/schedules/js/update_main_tutorial_schedule'}
    end



  end

  def save_updated_main_tutorial

    @slot_schedule = SlotSchedule.find_by(:slot_id=>params[:slot_schedule][:slot_id],:master_day_id=>params[:slot_schedule][:master_day_id],:term_id=>params[:slot_schedule][:term_id],:user_id=>params[:slot_schedule][:tutor_id])
    @slot_schedule.tutor_group_id = params[:tutor_group_id]
    if params[:slot_schedule][:subject_id].present?
      @slot_schedule.subject_id = params[:sub_subject_id][:subject_id]
    end
    if params[:sub_subject_id][:subject_id].present? # Save sub subject id here for all cases. not sure why is it in a if condition
      @slot_schedule.sub_subject_id = params[:sub_subject_id][:subject_id]
    end

    @slot_schedule.save

    if !@slot_schedule.students.blank?
      @slot_schedule.students.destroy_all
    end
    if params[:students].present?
      params[:students].each do |key,value|

        @slot_stud = SlotScheduleStudent.new
        @slot_stud.slot_schedule_id       = @slot_schedule.id
        @slot_stud.student_id             = key
        @slot_stud.associated_group_id    = params[:tutor_group]
        @slot_stud.associated_group_type  = "TutorGroup"
        @slot_stud.slot_id                = params[:slot_schedule][:slot_id]
        @slot_stud.term_id                = params[:slot_schedule][:term_id]
        @slot_stud.master_day_id          = params[:slot_schedule][:master_day_id]
        @slot_stud.save
      end
    end
    redirect_to :back
  end

  #check-later
  # def open_edit_schedule_modal

  #   @slot_schedule = SlotSchedule.find_by(:slot_id=>params[:slot_id],:master_day_id=>params[:day_id],:term_id=>params[:term_id])
  #   @subjects=Subject.where(is_core: false, is_pivats: false, is_lunch: false, is_tutorial: false)
  #   @slot=Slot.find_by(:id => params[:slot_id])
  #   @day=MasterDay.find_by(:id=>params[:day_id])
  #   @term= MasterTerm.find_by(:id=>params[:term_id])
  #   respond_to do |format|
  #     format.js {render '/schedules/js/open_edit_schedule_modal'}
  #   end
  # end

  #check-later
  # def remove_schedule_slot

  #   @slot_schedule = SlotSchedule.find_by(:slot_id=>params[:slot_id],:master_day_id=>params[:day_id],:term_id=>params[:term_id])
  #   @subjects=Subject.where(is_core: false, is_pivats: false, is_lunch: false, is_tutorial: false)
  #   @slot=Slot.find_by(:id => params[:slot_id])
  #   @day=MasterDay.find_by(:id=>params[:day_id])
  #   @term= MasterTerm.find_by(:id=>params[:term_id])
  #   @schedule_display = params[:schedule_display]

  #   if @slot_schedule.destroy

  #     @slot_schedule.slot_schedule_students.destroy_all

  #     respond_to do |format|
  #       format.js {render '/schedules/js/remove_schedule_slot'}
  #     end
  #   end
  # end


  def on_subject_change_show_its_sub_subjects_while_creating_schedule

    @sub_subjects=SubSubject.where(:subject_id=>params[:subject_id])
    respond_to do |format|
      format.js {render '/schedules/js/on_subject_change_show_its_sub_subjects_while_creating_schedule'}
    end

  end

  def on_learning_group_change_show_students_while_creating_schedule
    @phases=Phase.where(academic_session_id:  session[:global_academic_session])

    @learning_group= LearningGroup.find(params[:learning_group_id])
    @learning_group_students= @learning_group.students

    # Student.all.each do |student|
    #   student.temp_schedule_user_id=0
    #   student.save
    # end
    #for remove userid
    Student.where(temp_schedule_user_id: current_user.id).each do |stud|
      stud.temp_schedule_user_id=0
      stud.save
    end

    @learning_group_students.each do |stud|
      stud.temp_schedule_user_id=current_user.id
      stud.save
    end
    respond_to do |format|
      format.js {render '/schedules/js/on_learning_group_change_show_students_while_creating_schedule'}
    end

  end

  def on_tg_select_show_students_while_creating_main_tutorial_schedule

    @phases=Phase.where(academic_session_id:  session[:global_academic_session])

    @tutor_group= TutorGroup.find(params[:tutor_group_id])
    @tutor_group_students= @tutor_group.students
    # Student.all.each do |student|
    #   student.temp_schedule_user_id=0
    #   student.save
    # end
    #for remove userid
    Student.where(temp_schedule_user_id: current_user.id).each do |stud|
      stud.temp_schedule_user_id=0
      stud.save
    end

    @tutor_group_students.each do |stud|
      stud.temp_schedule_user_id=current_user.id
      stud.save
    end

    respond_to do |format|
      format.js {render '/schedules/js/new/show_tg_students'}
    end

  end

  def add_lg_student_schedule

    @phases=Phase.where(academic_session_id:  session[:global_academic_session])

    @stud=Student.find(params[:student_id])
    # @student_phase = @stud.show_phase_id
    @student_phase = @stud.phase_id(session[:global_academic_session])

    @stud.temp_schedule_user_id=current_user.id
    @stud.save

    @learning_group= LearningGroup.find(params[:lg_id])

    @learning_group_students= Student.where(temp_schedule_user_id: current_user.id)
    respond_to do |format|
      format.js {render '/schedules/js/add_lg_student_schedule'}
    end
  end

  def add_tg_student_schedule

    @phases=Phase.where(academic_session_id:  session[:global_academic_session])
    @stud=Student.find(params[:student_id])
    @student_phase = @stud.phase_id(session[:global_academic_session])
    @stud.temp_schedule_user_id=current_user.id
    @stud.save
    @tutor_group= TutorGroup.find(params[:tg_id])

    @tutor_group_students= Student.where(temp_schedule_user_id: current_user.id)
    respond_to do |format|
      format.js {render '/schedules/js/new/add_tg_student_schedule'}
    end
  end


  def remove_lg_student_schedule

    @phases=Phase.where(academic_session_id:  session[:global_academic_session])
    @stud=Student.find(params[:student_id])
    # @student_phase = @stud.show_phase_id
    @student_phase = @stud.phase_id(session[:global_academic_session])

    @stud.temp_schedule_user_id=0
    @stud.save
    @learning_group= LearningGroup.find(params[:lg_id])

    @learning_group_students= Student.where(temp_schedule_user_id: current_user.id)
    respond_to do |format|
      format.js {render '/schedules/js/remove_lg_student_schedule'}
    end
  end

  def remove_tg_student_schedule
    @phases=Phase.where(academic_session_id:  session[:global_academic_session])
    @stud=Student.find(params[:student_id])
    @student_phase = @stud.phase_id(session[:global_academic_session])

    @stud.temp_schedule_user_id=0
    @stud.save
    @tutor_group= TutorGroup.find(params[:tg_id])

    @tutor_group_students= Student.where(temp_schedule_user_id: current_user.id)
    respond_to do |format|
      format.js {render '/schedules/js/new/remove_tg_student_schedule'}
    end
  end
  def verify_sub_subject

    @sub_subject_tutor = SubSubject.find(params[:sub_subject])

    @subjects=Subject.where(is_core: false, is_pivats: false, is_lunch: false, is_tutorial: false)
    @slot=Slot.find_by(:id => params[:slot_id])
    @day=MasterDay.find_by(:id=>params[:day_id])


    @schedule_display = JSON.parse params[:schedule_display].to_s.gsub('=>', ':')
    @learning_groups = LearningGroup.where(academic_session_id: @schedule_display["academic_session_id"] )

    @term = Term.find_by(master_term_id: @schedule_display["master_term_id"].to_i, academic_session_id: @schedule_display["academic_session_id"].to_i)
    @tutor_group = TutorGroup.find_by(:user_id => params[:current_tutor],:academic_session_id=>session[:global_academic_session])

    if !@tutor_group.blank?
      @tutor_group_students = @tutor_group.students
    end

    respond_to do |format|
      #if @sub_subject_tutor.is_tutorial
        format.js {render '/schedules/js/verify_sub_subject'}
      #else

        # format.js {render '/schedules/js/not_verify_sub_subject'}
      #end
    end

  end

  def reset_schedule_student

    @studentss=Student.where(temp_schedule_user_id: current_user.id)
    @studentss.each do |stud|
      stud.temp_schedule_user_id=0
      stud.save
    end
    render :nothing => true
  end


  def delete_schedule

    @slot_schedule = SlotSchedule.find_by(:slot_id=>params[:slot_id],:master_day_id=>params[:day_id],:term_id=>params[:term_id],:user_id=> params[:tutor_id])
    @subjects=Subject.where(is_core: false, is_pivats: false, is_lunch: false, is_tutorial: false)
    @slot=Slot.find_by(:id => params[:slot_id])
    @day=MasterDay.find_by(:id=>params[:day_id])
    @term= MasterTerm.find_by(:id=>params[:term_id])
    @schedule_display = params[:schedule_display]

    if @slot_schedule.destroy

      @slot_schedule.slot_schedule_students.destroy_all

      respond_to do |format|
        format.html {redirect_to :back}
      end

    end
  end


  # request
  def clone_schedule

    if (Term.find(session[:global_current_term]).master_term.name == "term-1" && Term.find(session[:global_current_term]).clone_flag == false)

      copy_schedule

    elsif  (Term.find(session[:global_current_term]).master_term.name == "term-2" && Term.find(session[:global_current_term]).clone_flag == false)

      copy_schedule

    else

      flash[:alert] = "You cannot extend schedules for this term."
      redirect_to :back

    end

  end

  def copy_schedule

    @slot_schedules = SlotSchedule.where("term_id = ? AND academic_session_id = ?",session[:global_current_term],session[:global_academic_session])

    # Delete existing next term schedules
    @next_term_schedules = SlotSchedule.where("term_id = ? AND academic_session_id = ?",session[:global_current_term]+1, session[:global_academic_session])

    @next_term_schedules.each do |schedule|
      schedule.slot_schedule_students.destroy_all
    end

    @next_term_schedules.destroy_all

    @term = Term.find(session[:global_current_term])
    @term.clone_flag = true
    @term.save

    # Create next term schedule
    if @slot_schedules.present?
      @slot_schedules.each do |slot|
        slot.attributes = {:term_id => session[:global_current_term] + 1}
        new_slot = SlotSchedule.create(slot.attributes.except("id"," created_at","updated_at"))

        slot.slot_schedule_students.each do |student|
          student.attributes = {:term_id => session[:global_current_term] + 1,:slot_schedule_id=> new_slot.id}
          SlotScheduleStudent.create(student.attributes.except("id","created_at","updated_at"))
        end
      end
      flash[:notice] = "Schedule successfully created for #{(Term.find(session[:global_current_term] + 1).master_term.display_name)}"
      redirect_to :back

    else

      @term = Term.find(session[:global_current_term])
      @term.clone_flag = false
      @term.save

      flash[:alert] = "Schedule for the current term is empty and cannot be extended."
      redirect_to :back

    end

  end

# new
def create_tutorial_schedule
 @slot_schedule = SlotSchedule.new
 @schedule_display = JSON.parse params[:schedule_display].to_s.gsub('=>', ':')
 @term = Term.find_by(master_term_id: @schedule_display["master_term_id"].to_i, academic_session_id: @schedule_display["academic_session_id"].to_i)
 @slot=Slot.find_by(:id => params[:slot_id])
 @master_day=MasterDay.find_by(:id=>params[:day_id])
 respond_to do |format|
  format.js {render '/schedules/js/new/create_tutorial_schedule'}
end
end


  # def open_create_schedule_main_tutorial_modal
  def create_tutorial_schedule_show_ppa_or_tg
    
    @slot_schedule = SlotSchedule.new

    @subjects=Subject.where(is_core: false, is_pivats: false, is_lunch: false, is_tutorial: false)
    @slot=Slot.find_by(:id => params[:slot_id])
    @master_day=MasterDay.find_by(:id=>params[:day_id])


    @schedule_display = JSON.parse params[:schedule_display].to_s.gsub('=>', ':')
    @tutor_groups = TutorGroup.where(academic_session_id: @schedule_display["academic_session_id"] )
    # for remove user id
    Student.where(temp_schedule_user_id: current_user.id).each do |stud|
      stud.temp_schedule_user_id=0
      stud.save
    end

    @term = Term.find_by(master_term_id: @schedule_display["master_term_id"].to_i, academic_session_id: @schedule_display["academic_session_id"].to_i)
    respond_to do |format|
      if params[:is_ppa] == 'true'
        format.js {render '/schedules/js/new/show_ppa_tutorial'}
      else
        format.js {render '/schedules/js/new/show_only_tutorial'}
      end

    end

  end


  def select_lg_tg
       @slot=Slot.find_by(:id => params[:slot_id])
    @day=MasterDay.find_by(:id=>params[:day_id])


    @schedule_display = JSON.parse params[:schedule_display].to_s.gsub('=>', ':')
    @learning_groups = LearningGroup.where(academic_session_id: @schedule_display["academic_session_id"] )

    @term = Term.find_by(master_term_id: @schedule_display["master_term_id"].to_i, academic_session_id: @schedule_display["academic_session_id"].to_i)
    # @tutor_groups = TutorGroup.find_by(:user_id => params[:current_tutor],:academic_session_id=>session[:global_academic_session])
    @tutor_groups = TutorGroup.where(:academic_session_id=> @schedule_display["academic_session_id"])

    if !@tutor_group.blank?
      @tutor_group_students = @tutor_group.students
    end

      respond_to do |format|
        format.js {render '/schedules/js/new/select_lg_tg'}
    end 
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def slot_schedule_params
    params.require(:slot_schedule).permit(:slot_id,:master_day_id,:subject_id,:term_id)
  end
end
