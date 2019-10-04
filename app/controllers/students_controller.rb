require 'spreadsheet'
class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index

    if params[:view]=="Deactive"
      @deactive =true
      @students=Student.only_deleted
    else
      @students = Student.all
    end
    @student = Student.new
    @years = MasterGrade.all

    t_auth_stud = Student.first  
    if !t_auth_stud.blank?
      authorize t_auth_stud
    end

  # @student.school_year_students.build
  end

  # GET /students/1
  # GET /students/1.json
  def show

    @current_lo = 1 #for sending current state of lo as default 1 to have similar params as other method 
    @master_csd_axis = MasterCsdAxis.all

    @show_completed = false
    @show_closed = false

    if params[:completed]
      @show_completed = true
    end

    if params[:closed]
      @show_closed = true
    end

    @temp_learning_objectives = @student.student_learning_objectives.where("is_closed = ? AND is_completed = ?", @show_closed, @show_completed)

    @ordered_rfl = @temp_learning_objectives.find_all{|a| a.global_lo_type=="GlobalRflObjective"}.sort_by{|a| [a.global_lo.position, a.assigned_date, a.id] }
    @ordered_pivats = @temp_learning_objectives.find_all{|a| a.global_lo_type=="GlobalPivatsSublevel"}.sort_by{|a| [a.global_lo.global_pivats_objective.sub_subject.subject.position, a.global_lo.global_pivats_objective.sub_subject.position, a.assigned_date, a.id] }
    @ordered_custom = @temp_learning_objectives.find_all{|a| a.global_lo_type=="GlobalCustomObjective"}.sort_by{|a| [a.assigned_date, a.id] }


    @student_learning_objectives = @ordered_rfl + @ordered_pivats + @ordered_custom

    # Schedule fields

    @selected_academic_session = session[:global_academic_session]
    @selected_student = params[:id]

    @academic_sessions = AcademicSession.all.order("id DESC")

    @master_days = MasterDay.all
    # @slots = Slot.where(academic_session_id: @selected_academic_session, is_scheduled_time: true)
    @slots = Slot.where(academic_session_id: @selected_academic_session, is_taught_time: true)


    # @term = Term.where("academic_session_id = ? AND start_date < ? AND end_date > ?", @selected_academic_session, Time.now, Time.now).last
    @term=Term.find(session[:global_current_term])
    @slot_schedules = @student.slot_schedules.where(term_id: @term.id)
    # SlotSchedule.where(term_id: @term.id)  

    @has_schedule = @slot_schedules.blank? ? false : true
    #

    # Report fields
    @reports = @student.reports.group_by { |r| r.academic_session_id }
    @report_years = @reports.keys.reverse

  end

  # GET /students/new
  def new
    @student = Student.new
  end
    

  # GET /students/1/edit
  def edit

  end

  # POST /students
  # POST /students.json
  def create

    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save

        @student_annual_grade = AnnualGradeStudent.new      
        if params[:is_pfc]
          @student_annual_grade.is_pfc = params[:is_pfc]
        end 
        
        @student_annual_grade.annual_grade_id = AnnualGrade.find_by(academic_session_id: session[:global_academic_session], master_grade_id: params[:school_year]).id
        @student_annual_grade.student_id = @student.id
        @student_annual_grade.save

        if !params[:learning_group].blank?
          lg = LearningGroup.find(params[:learning_group])
          LearningGroupStudent.find_or_create_by(:academic_session_id=>session[:global_academic_session], student_id: @student.id, learning_group_id: lg.id) 
        end

        if !params[:tutor_group].blank?
          tg = TutorGroup.find(params[:tutor_group])
          TutorGroupStudent.find_or_create_by(:academic_session_id=>session[:global_academic_session], student_id: @student.id, tutor_group_id: tg.id) 
        end

        format.html { redirect_to students_path, notice: @student.name + ' was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update

    respond_to do |format|
      if @student.update(student_params)

        # @student_annual_grade = @student.annual_grade_students.last
        # @student_annual_grade = !@student.annual_grade_students.joins(:annual_grade).where("annual_grades.academic_session_id = ?", session[:global_academic_session]).blank? ? (@student.annual_grade_students.joins(:annual_grade).where("annual_grades.academic_session_id = ?", session[:global_academic_session]).first.is_pfc? ? "Yes" : "No") : ""
        @student_annual_grade = !@student.annual_grade_students.joins(:annual_grade).where("annual_grades.academic_session_id = ?", session[:global_academic_session]).blank? ? @student.annual_grade_students.joins(:annual_grade).where("annual_grades.academic_session_id = ?", session[:global_academic_session]).first : ""


        if params[:is_pfc]
          @student_annual_grade.is_pfc = params[:is_pfc]
        else
          if @student_annual_grade.is_pfc == true
            @student_annual_grade.is_pfc = false
          end
        end 

        @student_annual_grade.annual_grade_id = AnnualGrade.find_by(academic_session_id: session[:global_academic_session], master_grade_id: params[:school_year]).id

        @student_annual_grade.save

        format.html { redirect_to students_path, notice: @student.name + "'s details were successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy

    if @student.student_learning_objectives.present?
        @student.student_learning_objectives.each do |lo|
         lo.is_closed = true
         lo.save
    end
    end
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: @student.name + ' was successfully deactivated.' }
      format.json { head :no_content }
    end
  end




  # add add_student_from_modal_path

  def add_student
    @student = Student.new
    @master_grades = MasterGrade.all
    @current_grade = MasterGrade.all.first
    @current_pfc = false

    @show_lg_tg_options = true
    @learning_groups = LearningGroup.where(academic_session_id: session[:global_academic_session] )
    @tutor_groups = TutorGroup.where(academic_session_id: session[:global_academic_session] )

    @from_js = true
    respond_to do |format|
      format.js {render '/students/js/add_student'}
    end
  end
  # end

  # edit student from modal
  def edit_student
    @student = Student.find_by(:id=>params[:student_id])

    @master_grades = MasterGrade.all
    # @current_grade = @student.annual_grade_students.last.annual_grade.master_grade

    @current_grade = !@student.annual_grade_students.joins(:annual_grade).where("annual_grades.academic_session_id = ?", session[:global_academic_session]).blank? ? @student.annual_grade_students.joins(:annual_grade).where("annual_grades.academic_session_id = ?", session[:global_academic_session]).first.annual_grade.master_grade : 0

    # @current_pfc = @student.annual_grade_students.last.is_pfc

    @current_pfc = !@student.annual_grade_students.joins(:annual_grade).where("annual_grades.academic_session_id = ?", session[:global_academic_session]).blank? ? @student.annual_grade_students.joins(:annual_grade).where("annual_grades.academic_session_id = ?", session[:global_academic_session]).first.is_pfc : false


    @show_lg_tg_options = false    

    respond_to do |format|
      format.js {render '/students/js/edit_student'}
    end

  end
  # end

  def edit_student_important_info

    @student=Student.find_by(:id=>params[:student_id])

    respond_to do |format|
      format.js {render '/students/js/edit_student_important_info'}
    end
  end


  def assign_new_learning_objective

    @master_csd_axis=MasterCsdAxis.all
    @global_pivats_objectives=GlobalPivatsObjective.all
    # @custom_global_pivats_objectives=GlobalPivatsObjective.pluck(:p_level).collect{|c| c.split.join}.uniq
    @custom_global_pivats_objectives=MasterPLevel.pluck(:name)

  @p_level =MasterPLevel.pluck(:name)
       @p_sublevel = MasterPSubLevel.pluck(:name)
    @student=Student.find_by(:id=>params[:id])
    @subjects=Subject.all
    @pivats_subjects=Subject.where(is_pivats: true)
    @global_rfl_objective=GlobalRflObjective.all
    @student_lo=StudentLearningObjective.new
    respond_to do |format|
      format.js {render '/students/js/assign_new_learning_objective'}
    end
  end

  def save_rfl_learning_objective

    @student_lo=StudentLearningObjective.new
    @student_lo.student_id=params[:student_learning_objective][:student_id]
    @student_lo.title=params[:student_learning_objective][:title]
    @student_lo.academic_session_id=session[:global_academic_session]
    @student_lo.term_id=session[:global_current_term] 
    @student_lo.global_lo_id=params[:student_learning_objective][:global_lo_id]
    @student_lo.global_lo_type="GlobalRflObjective"
    @student_lo.description=params[:student_learning_objective][:description]
    @student_lo.user_id=current_user.id
    @student_lo.assigned_date=Time.now
    @student_lo.target_date=params[:student_learning_objective][:target_date]
    @student_lo.save
    if params[:master_axis_id].present?
      params[:master_axis_id].each_with_index do |master_axis_id, index|
        @student_lo_target = StudentLearningObjectiveTarget.new
        @student_lo_target.student_learning_objective_id = @student_lo.id
        @student_lo_target.master_csd_axis_id = master_axis_id
        @student_lo_target.baseline_value = params[:base_axis_value][index]
        @student_lo_target.target_value = params[:target_axis_value][index]
        @student_lo_target.save
      end
    end
    remove_alert_item("New Learning Objective", @student_lo.student_id, "Student", nil, nil)

    redirect_to :back, notice: 'RFL Learning Objective was successfully created.'


  end


  def save_pivats_learning_objective
 
    @student_lo=StudentLearningObjective.new
    @student_lo.student_id=params[:student_learning_objective][:student_id]
    # @student_lo.title=params[:title]
    # remove tags from description since title is not summernote'd
    @student_lo.title = ActionView::Base.full_sanitizer.sanitize(params[:description])
    @student_lo.academic_session_id=session[:global_academic_session]
    @student_lo.term_id=session[:global_current_term] 

    @student_lo.subject_id=params[:student_learning_objective][:subject_id]
    @student_lo.sub_subject_id=params[:sub_subject_id]

    @student_lo.global_lo_id=params[:global_lo_id]
    @student_lo.p_sublevel=GlobalPivatsSublevel.find(params[:global_lo_id]).alphabet
    # @student_lo.global_lo_type="GlobalPivatsObjective"
    @student_lo.global_lo_type="GlobalPivatsSublevel"
    @student_lo.description=params[:description]
    @student_lo.p_level=params[:p_level]
    @student_lo.user_id=current_user.id
    @student_lo.assigned_date=Time.now
    @student_lo.target_date=params[:target_date]

    if !params[:custom_plevel].blank?
         @student_lo.p_level= params[:custom_plevel]
    end
    if !params[:custom_psublevel].blank?
      @student_lo.p_sublevel= params[:custom_psublevel]
    end
   
    @student_lo.save

    if params[:master_axis_id].present?
      params[:master_axis_id].each_with_index do |master_axis_id, index|
        @student_lo_target = StudentLearningObjectiveTarget.new
        @student_lo_target.student_learning_objective_id = @student_lo.id
        @student_lo_target.master_csd_axis_id = master_axis_id
        @student_lo_target.baseline_value = params[:base_axis_value][index]
        @student_lo_target.target_value = params[:target_axis_value][index]
        @student_lo_target.save
      end
    end
    remove_alert_item("New Learning Objective", @student_lo.student_id, "Student", nil, nil)

    redirect_to :back, notice: 'PIVATS Learning Objective was successfully created.'
  end

  def save_custom_learning_objective
    @custom=GlobalCustomObjective.new
    if params[:student_learning_objective][:subject_id].present?
      @custom.subject_name=Subject.find(params[:student_learning_objective][:subject_id]).name
    end
    @custom.title=params[:student_learning_objective][:title]
    @custom.subject_id=params[:student_learning_objective][:subject_id]
    if params[:sub_subject_id].present?
      @custom.sub_subject_name=SubSubject.find(params[:sub_subject_id]).name
    end
    @custom.sub_subject_id=params[:sub_subject_id]
    @custom.description=params[:description]
    #if params[:plevel]
  # @custom.p_level= GlobalPivatsObjective.find(params[:plevel]).p_level #* TODO proper way *#
  #@custom.p_level= params[:plevel]#* TODO proper way *#
  #end

    if !params[:custom_plevel].blank?
         @custom.p_level= params[:custom_plevel]
         @custom.p_sublevel=  params[:custom_psublevel]

    end
    


  if @custom.save
    @student_lo=StudentLearningObjective.new
    @student_lo.student_id=params[:student_learning_objective][:student_id]
    @student_lo.title=params[:student_learning_objective][:title]
    @student_lo.academic_session_id=session[:global_academic_session]
    @student_lo.term_id=session[:global_current_term] 
    
    @student_lo.subject_id=params[:student_learning_objective][:subject_id]
    @student_lo.sub_subject_id=params[:sub_subject_id]

    @student_lo.global_lo_id=@custom.id
    @student_lo.global_lo_type="GlobalCustomObjective"
    @student_lo.description=params[:description]
  # @student_lo.p_level=GlobalPivatsObjective.find(params[:plevel]).p_level #* TODO proper way *#

  @student_lo.p_level=  params[:custom_plevel]#* TODO proper way *#
  @student_lo.p_sublevel=  params[:custom_psublevel]#* TODO proper way *#
  @student_lo.user_id=current_user.id
  @student_lo.assigned_date=Time.now
  @student_lo.target_date=params[:student_learning_objective][:target_date]
  @student_lo.save

  if params[:master_axis_id].present?
    params[:master_axis_id].each_with_index do |master_axis_id, index|
      @student_lo_target = StudentLearningObjectiveTarget.new
      @student_lo_target.student_learning_objective_id = @student_lo.id
      @student_lo_target.master_csd_axis_id = master_axis_id
      @student_lo_target.baseline_value = params[:base_axis_value][index]
      @student_lo_target.target_value = params[:target_axis_value][index]
      @student_lo_target.save
    end
  end
  end
  remove_alert_item("New Learning Objective", @student_lo.student_id, "Student", nil, nil)

  redirect_to :back, notice: 'Custom Learning Objective was successfully created.'

  end

  def show_pivats_sub_subjects

    @subjects=Subject.all
    @pivats_subjects=Subject.where(is_pivats: true)

    @student_lo=StudentLearningObjective.new

    @sub_subjects= SubSubject.where(:subject_id=>params[:sub_subject])
    @from_js = true
    respond_to do |format|
      format.js {render '/students/js/show_pivats_sub_subjects'}
    end

  end

  def show_custom_sub_subjects

    @subjects=Subject.all
    @pivats_subjects=Subject.where(is_pivats: true)

    @student_lo=StudentLearningObjective.new

    @sub_subjects= SubSubject.where(:subject_id=>params[:sub_subject])
    @from_js = true
    respond_to do |format|
      format.js {render '/students/js/show_custom_sub_subjects'}
    end
  end


  def show_plevel_pivats

    @global_pivats_objectives=GlobalPivatsObjective.where(:sub_subject_id => params[:sub_subject])
    @from_js = true
    respond_to do |format|
      format.js {render '/students/js/show_plevel_pivats'}
    end

  end

  def plevel_description
       @p_level =MasterPLevel.pluck(:name)
       @p_sublevel = MasterPSubLevel.pluck(:name)

    @global_pivat = GlobalPivatsObjective.find(params[:id])
    @global_pivats_objectives_desc=GlobalPivatsSublevel.where(:global_pivats_objective_id=>params[:id])
    @master_csd_axis=MasterCsdAxis.all

    respond_to do |format|
      format.js {render '/students/js/plevel_description'}
    end
  end


  def edit_learning_objective

      @custom_p_level = MasterPLevel.pluck(:name)

       @p_sublevel = MasterPSubLevel.pluck(:name)
    @master_csd_axis=MasterCsdAxis.all
    @global_pivats_objectives=GlobalPivatsObjective.all
    # @subjects=Subject.all
    # @pivats_subjects=Subject.where(is_pivats: true)

    # @sub_subjects=SubSubject.all
    @student_lo=StudentLearningObjective.find_by(:id =>params[:lo])
    @sub_subject_name = (!@student_lo.sub_subject_id.blank? ? SubSubject.with_deleted.find(@student_lo.sub_subject_id).name : "Unavailable")
    @subject_name = (!@student_lo.sub_subject_id.blank? ? SubSubject.with_deleted.find(@student_lo.sub_subject_id).subject.name : "Unavailable")
    @p_level = @student_lo.p_level

    respond_to do |format|
      if params[:staff]=="true"
        format.js {render '/staff_profiles/js/edit_lo_staff'}
      else
        format.js {render '/students/js/edit_learning_objective'}
      end
    end
  end

  def update_pivats_learning_objective

    @student_lo=StudentLearningObjective.find_by(:id =>params[:student_learning_objective][:id])

    @student_lo.description=params[:student_learning_objective][:description]
    @student_lo.title=params[:student_learning_objective][:title]

    if params[:master_axis_id].present?
      params[:master_axis_id].each_with_index do |master_axis_id, index|
        @student_lo_target = StudentLearningObjectiveTarget.find_by(:student_learning_objective_id=>@student_lo.id, :master_csd_axis_id=>master_axis_id)
        #@student_lo_target.student_learning_objective_id = @student_lo.id
        #@student_lo_target.master_csd_axis_id = master_axis_id
        if params[:base_axis_value][index].present?
        @student_lo_target.baseline_value = params[:base_axis_value][index]
      end
      if params[:target_axis_value][index].present?
        @student_lo_target.target_value = params[:target_axis_value][index]
      end
      
    if !params[:custom_plevel].blank?
         @student_lo.p_level= params[:custom_plevel]
    end
    if !params[:custom_psublevel].blank?
      @student_lo.p_sublevel= params[:custom_psublevel]
    end
        @student_lo_target.save
      end
    end


    @student_lo.target_date=params[:student_learning_objective][:target_date]
    @student_lo.save
    redirect_to :back
  end


  def temp_complete_learning_objective
 
    @current = []
    @closed = [] 
    @completed = []
    @master_csd_axis = MasterCsdAxis.all

    @student_lo=StudentLearningObjective.find_by(:id =>params[:lo])
    @student_lo.temp_complete=true
    @student_lo.temp_complete_user_id=current_user.id
    @student_lo.save
    @student=@student_lo.student
    if params[:current_lo_state]=="1"
      @current_lo=1
      @current=@student.student_learning_objectives.where("is_closed = ? AND is_completed = ?", false, false) 
    end

    if params[:closed_lo_state]=="1"
      @closed_lo=1
      @closed=@student.student_learning_objectives.where("is_closed = ?" , true)
    end

    if params[:completed_lo_state]=="1"
      @completed_lo=1
      @completed=@student.student_learning_objectives.where("is_completed = ?", true)

    end

    @student_learning_objectives = @current + @closed + @completed
        Resque.enqueue(EmailAlert, @student_lo.id,session[:global_academic_session],@student_lo.class.name, action_name,current_user.id)

  # Create s notification on student profile for teacher has marked a learning objective ‘achieved’.


  respond_to do |format|
    # flash[:alert] = 'A notification has been sent to the tutor.'
    format.js {render '/students/js/temp_complete_learning_objective'}
  end

  end

  def temp_accept_learning_objective

    @current = []
    @closed = [] 
    @completed = []
    @master_csd_axis = MasterCsdAxis.all
    
    @student_lo=StudentLearningObjective.find_by(:id =>params[:lo])
    @student_lo.temp_complete=true
    @student_lo.is_completed=true
    @student_lo.achieved_date=Time.now
    @student_lo.save

    @student=@student_lo.student
    if params[:current_lo_state]=="1"
      @current_lo=1
      @current=@student.student_learning_objectives.where("is_closed = ? AND is_completed = ?", false, false) 
    end

    if params[:closed_lo_state]=="1"
      @closed_lo=1
      @closed=@student.student_learning_objectives.where("is_closed = ?" , true)
    end

    if params[:completed_lo_state]=="1"
      @completed_lo=1
      @completed=@student.student_learning_objectives.where("is_completed = ?", true)

    end
    @student_learning_objectives = @current + @closed + @completed
    respond_to do |format|
  # flash[:alert] = 'A notification has been sent to the tutor.'
  format.js {render '/students/js/temp_accept_learning_objective'}
  end
  end

  def temp_decline_learning_objective

    @current = []
    @closed = [] 
    @completed = []
    @master_csd_axis = MasterCsdAxis.all

    @student_lo = StudentLearningObjective.find_by(:id =>params[:lo])
    @student_lo.temp_complete = false
    # @student_lo.achieved_date = nil
    @student_lo.temp_complete_user_id = nil
    @student_lo.save
    
    @student=@student_lo.student
    if params[:current_lo_state]=="1"
      @current_lo=1
      @current=@student.student_learning_objectives.where("is_closed = ? AND is_completed = ?", false, false) 
    end

    if params[:closed_lo_state]=="1"
      @closed_lo=1
      @closed=@student.student_learning_objectives.where("is_closed = ?" , true)
    end

    if params[:completed_lo_state]=="1"
      @completed_lo=1
      @completed=@student.student_learning_objectives.where("is_completed = ?", true)

    end
    @student_learning_objectives = @current + @closed + @completed

    Resque.enqueue(EmailAlert, @student_lo.id,session[:global_academic_session],@student_lo.class.name, action_name,current_user.id)

  respond_to do |format|
  # flash[:alert] = 'A notification has been sent to the tutor.'
  format.js {render '/students/js/temp_decline_learning_objective'}
  end
  end

  def set_objective_achievement
    @student_achievement = StudentLearningObjectiveAchievement.new
    @student_achievement.student_learning_objective_id = params[:student_objective_id].to_i  
    @student_achievement.master_csd_axis_id = params[:master_axis_id].to_i 
    @student_achievement.achievement_value = params[:axis_value].to_i
    @minaxisvalue = params[:minaxisvalue]
    @maxaxisvalue = params[:maxaxisvalue] 
    if @student_achievement.save!
      respond_to do |format|
        format.js 
      end  
    end
  end



  def close_lo_learning_objective

    @student_lo=StudentLearningObjective.find_by(:id =>params[:lo])
    @student_lo.is_closed=true
    @student_lo.save
    @current = []
    @closed = [] 
    @completed = []

    @student=Student.find(params[:student_id])

    @master_csd_axis = MasterCsdAxis.all

    if params[:current_lo_state]=="1"
      @current_lo=1
      @current=@student.student_learning_objectives.where("is_closed = ? AND is_completed = ?", false, false) 
    end

    if params[:closed_lo_state]=="1"
      @closed_lo=1
      @closed=@student.student_learning_objectives.where("is_closed = ?" , true)
    end

    if params[:completed_lo_state]=="1"
      @completed_lo=1
      @completed=@student.student_learning_objectives.where("is_completed = ?", true)

    end

    @student_learning_objectives = @current + @closed + @completed

    Resque.enqueue(EmailAlert, @student_lo.id,session[:global_academic_session], @student_lo.class.name, action_name,current_user.id)

    respond_to do |format|
  format.js {render '/students/js/close_lo_learning_objective'}
  end
  end

def reopen_lo_learning_objective

   @student_lo=StudentLearningObjective.find_by(:id =>params[:lo])
    @student_lo.is_closed=false
    @student_lo.save

    @current = []
    @closed = [] 
    @completed = []

    @student=Student.find(params[:student_id])

    @master_csd_axis = MasterCsdAxis.all

    if params[:current_lo_state]=="1"
      @current_lo=1
      @current=@student.student_learning_objectives.where("is_closed = ? AND is_completed = ?", false, false) 
    end

    if params[:closed_lo_state]=="1"
      @closed_lo=1
      @closed=@student.student_learning_objectives.where("is_closed = ?" , true)
    end

    if params[:completed_lo_state]=="1"
      @completed_lo=1
      @completed=@student.student_learning_objectives.where("is_completed = ?", true)

    end

    @student_learning_objectives = @current + @closed + @completed



    respond_to do |format|
      format.js {render '/students/js/reopen_lo_learning_objective'}
    end
end



def unachieve_lo_learning_objective

    @student_lo=StudentLearningObjective.find_by(:id =>params[:lo])
    @student_lo.is_completed = false
    @student_lo.temp_complete = false
    @student_lo.achieved_date = nil
    @student_lo.save

    @current = []
    @closed = [] 
    @completed = []

    @student=Student.find(params[:student_id])

    @master_csd_axis = MasterCsdAxis.all

    if params[:current_lo_state]=="1"
      @current_lo=1
      @current=@student.student_learning_objectives.where("is_closed = ? AND is_completed = ?", false, false) 
    end

    if params[:closed_lo_state]=="1"
      @closed_lo=1
      @closed=@student.student_learning_objectives.where("is_closed = ?" , true)
    end

    if params[:completed_lo_state]=="1"
      @completed_lo=1
      @completed=@student.student_learning_objectives.where("is_completed = ?", true)

    end

    @student_learning_objectives = @current + @closed + @completed



    respond_to do |format|
      format.js {render '/students/js/unachieve_lo_learning_objective'}
    end
end

def delete_lo_learning_objective

    @student_lo=StudentLearningObjective.find_by(:id =>params[:lo])
    @student=Student.find(params[:student_id])
    if @student_lo.report_objective.present? 
      flash[:alert] = 'This Learning Objective is already included in report and cannot be deleted.'
    else
      @student_lo.observations.each do |observation|
        observation.student_learning_objective_id = nil
        observation.student_id = @student.id
        observation.save
      end
      @student_lo.destroy
  end

    @current = []
    @closed = [] 
    @completed = []


    @master_csd_axis = MasterCsdAxis.all

    if params[:current_lo_state]=="1"
      @current_lo=1
      @current=@student.student_learning_objectives.where("is_closed = ? AND is_completed = ?", false, false) 
    end

    if params[:closed_lo_state]=="1"
      @closed_lo=1
      @closed=@student.student_learning_objectives.where("is_closed = ?" , true)
    end

    if params[:completed_lo_state]=="1"
      @completed_lo=1
      @completed=@student.student_learning_objectives.where("is_completed = ?", true)

    end

    @student_learning_objectives = @current + @closed + @completed

    redirect_to :back
    # respond_to do |format|
    #   format.js {render '/students/js/delete_lo_learning_objective'}
    # end
end


  def add_focus_class_to_lo
    @lo_id=StudentLearningObjective.find(params[:lo_id])
  # if @lo_id.focus_classes.present?
  #  @student_learning_objectives_focus=StudentLearningObjectiveFocusSubject.new
  #  @user_schedule_subjects = current_user.slot_schedules.where(academic_session_id: session[:global_academic_session]).select(:sub_subject_id).map(&:sub_subject).uniq
  #   respond_to do |format|
  #   format.js {render '/students/js/update_focus_class_to_lo'}
  #   end
  # else
  #  @student_learning_objectives_focus=StudentLearningObjectiveFocusSubject.new
  #  @user_schedule_subjects = @lo_id.user.slot_schedules.where(academic_session_id: session[:global_academic_session]).select(:sub_subject_id).map(&:sub_subject).uniq
  # respond_to do |format|
  #   format.js {render '/students/js/add_focus_class_to_lo'}
  #   end
  # end
  @student_learning_objectives_focus=StudentLearningObjectiveFocusSubject.new
  @user_schedule_subjects = current_user.slot_schedules.where(academic_session_id: session[:global_academic_session]).select(:sub_subject_id).map(&:sub_subject).uniq
  respond_to do |format|
    format.js {render '/students/js/add_focus_class_to_lo'}
  end

  end
  def save_focus

    if params[:sub_subject_id]

      params[:sub_subject_id].each do |sub|
  if sub[1] == "0" #unchecked box

    StudentLearningObjectiveFocusSubject.delete_all(academic_session_id: session[:global_academic_session], sub_subject_id: sub[0], student_learning_objective_id: params[:student_learning_objective_focus_subject][:student_learning_objectives_id])
  else
  #to do consider term_id
  @student_learning_objectives_focus=StudentLearningObjectiveFocusSubject.find_or_initialize_by(academic_session_id: session[:global_academic_session], sub_subject_id: sub[0], student_learning_objective_id: params[:student_learning_objective_focus_subject][:student_learning_objectives_id],user_id: current_user.id,term_id: session[:global_current_term])
  @student_learning_objectives_focus.save
  end
  # redirect_to :back
  end
  else

  #StudentLearningObjective.find(params[:student_learning_objective_focus_subject][:student_learning_objectives_id]).focus_classes.destroy_all
  end 
  redirect_to :back, notice: "The class was successfully added as focus to LO."
  end

  def show_focus_subject

    @lo=StudentLearningObjective.find(params[:lo_id])
    # @focus_classes=@lo.focus_classes.where(academic_session_id: session[:global_academic_session], term_id: session[:global_current_term], user_id: current_user.id)
    @focus_classes_current_user=@lo.focus_classes.where(academic_session_id: session[:global_academic_session], term_id: session[:global_current_term], user_id: current_user.id)
    @focus_classes_other_users=@lo.focus_classes.where('academic_session_id =? AND term_id = ? AND user_id != ?', session[:global_academic_session], session[:global_current_term], current_user.id)
    @group_focus = @focus_classes_other_users.group_by {|user| user[:user_id]}
    respond_to do |format|
      format.js {render '/students/js/show_focus_subject'}
    end
  end

  def show_closed_lo_student_index

    @current_cb_state = true
    @student=Student.find(params[:student_id])
    @master_csd_axis = MasterCsdAxis.all


    @student_learning_objectives = @student.student_learning_objectives.where("is_closed = ? AND is_completed = ?", false, false) + @student.student_learning_objectives.where("is_closed = ?", true)


    respond_to do |format|
      format.js {render '/students/js/show_closed_lo_student_index'}
    end
  end

  def show_completed_lo_student_index
    @student=Student.find(params[:student_id])
    @master_csd_axis = MasterCsdAxis.all
    @student_learning_objectives = @student.student_learning_objectives.where("is_closed = ? AND is_completed = ?", false, false) + @student.student_learning_objectives.where("is_completed = ?", true)

    respond_to do |format|
      # flash[:alert] = 'Please wait'

      format.js {render '/students/js/show_completed_lo_student_index'}
    end
  end

  def show_selected_lo_student_index

    @current = []
    @closed = [] 
    @completed = []

    @student=Student.with_deleted.find(params[:student_id])
    @master_csd_axis = MasterCsdAxis.all

    if params[:current_lo]=="1"
      @current_lo=1
      @current=@student.student_learning_objectives.where("is_closed = ? AND is_completed = ?", false, false) 
    end

    if params[:closed_lo]=="1"
      @closed_lo=1
      @closed=@student.student_learning_objectives.where("is_closed = ?" , true)
    end

    if params[:completed_lo]=="1"
      @completed_lo=1
      @completed=@student.student_learning_objectives.where("is_completed = ?", true)

    end

    @temp_learning_objectives = @current + @closed + @completed

    @ordered_rfl = @temp_learning_objectives.find_all{|a| a.global_lo_type=="GlobalRflObjective"}.sort_by{|a| [a.global_lo.position, a.assigned_date, a.id] }
    # @ordered_pivats = @temp_learning_objectives.find_all{|a| a.global_lo_type=="GlobalPivatsSublevel"}.sort_by{|a| [a.global_lo.sub_subject.subject.position, a.global_lo.sub_subject.position, a.assigned_date, a.id] }
    @ordered_pivats = @temp_learning_objectives.find_all{|a| a.global_lo_type=="GlobalPivatsSublevel"}.sort_by{|a| [a.global_lo.global_pivats_objective.sub_subject.subject.position, a.global_lo.global_pivats_objective.sub_subject.position, a.assigned_date, a.id] }
    @ordered_custom = @temp_learning_objectives.find_all{|a| a.global_lo_type=="GlobalCustomObjective"}.sort_by{|a| [a.assigned_date, a.id] }


    @student_learning_objectives = @ordered_rfl + @ordered_pivats + @ordered_custom

    respond_to do |format|
      format.js {render '/students/js/show_selected_lo_student_index'}
    end

  end


  def create_schedule_from_student_index

    @student_id=params[:student_id]
    @slot_schedule_student = SlotScheduleStudent.new
    @term = Term.find(session[:global_current_term])

    @slot=Slot.find(params[:slot_id])

    @master_day=MasterDay.find(params[:day_id])
    # @slot_schedules=SlotSchedule.where(slot_id: @slot.id,term_id: @term.id,master_day_id: @master_day.id)
    # Using hack tutor group not 0 OR learning group not 0 to exclude PPA - working
    @slot_schedules=SlotSchedule.where("slot_id = ? AND term_id = ? AND master_day_id = ? AND (tutor_group_id != 0 OR learning_group_id != 0)", @slot.id, @term.id, @master_day.id)

    respond_to do |format|
      format.js {render '/students/js/create_schedule_from_student_index'}
    end
  end


  def edit_schedule_student_show

    @slot_schedule_student = SlotScheduleStudent.new
    @student=Student.find(params[:student_id])
    @student_id=@student.id
    
    @slot=Slot.find_by(:id => params[:slot_id])
    @master_day=MasterDay.find_by(:id=>params[:master_day_id])
    @term= Term.find(params[:term_id])
    
    @student_schedules=@student.slot_schedules.where(slot_id: @slot.id,term_id: @term.id,master_day_id: @master_day.id)
    
    @slot_schedule = SlotSchedule.find_by(:slot_id=>params[:slot_id],:master_day_id=>params[:master_day_id],:term_id=>params[:term_id])
    
    # Using hack tutor group not 0 OR learning group not 0 to exclude PPA - working   
    # @slot_schedules=SlotSchedule.where(slot_id: @slot.id,term_id: @term.id,master_day_id: @master_day.id)
    @slot_schedules=SlotSchedule.where("slot_id = ? AND term_id = ? AND master_day_id = ? AND (tutor_group_id != 0 OR learning_group_id != 0)", @slot.id, @term.id, @master_day.id)
    
    @day = @master_day.id
    respond_to do |format|

      format.js {render '/students/js/edit_schedule_student_show'}

    end
  end
  def save_edit_schedule_student_show
    @scheduled= SlotScheduleStudent.where(student_id: params[:slot_schedule_student][:student_id],slot_id: params[:slot_schedule_student][:slot_id],term_id: params[:slot_schedule_student][:term_id],master_day_id: params[:slot_schedule_student][:master_day_id])
    @scheduled.delete_all

    @slot_students = SlotScheduleStudent.new
    @slot_students.slot_schedule_id=params[:slot_schedule_student][:slot_schedule_id]
    @slot_students.student_id=params[:slot_schedule_student][:student_id]

    
    @student = Student.find(params[:slot_schedule_student][:student_id])
    @slot_schedule = SlotSchedule.find(params[:slot_schedule_student][:slot_schedule_id])

    if @slot_schedule.sub_subject.is_tutorial? 
      @slot_students.associated_group_type="TutorGroup"
      @slot_students.associated_group_id = @student.show_tutor_group_id(session[:global_academic_session])
    else
      @slot_students.associated_group_type="LearningGroup"
      @slot_students.associated_group_id = @student.show_learning_group_id(session[:global_academic_session])
    end

    # @slot_students.associated_group_id=0
    # @slot_students.associated_group_type="LearningGroup"
    
    @slot_students.slot_id=params[:slot_schedule_student][:slot_id]
    @slot_students.term_id=params[:slot_schedule_student][:term_id]
    @slot_students.master_day_id=params[:slot_schedule_student][:master_day_id]
    @slot_students.save

    remove_alert_item("Schedule Conflict", @slot_students.student_id, "Student", nil, nil)


    respond_to do |format|
      format.html { redirect_to student_path(params[:slot_schedule_student][:student_id])  + "#tab_schedule", notice: 'Student was successfully scheduled.' }

    end

  end

  def delete_schedule_student_show

    @scheduled= SlotScheduleStudent.where(student_id: params[:student_id],slot_id: params[:slot_id],term_id: params[:term_id],master_day_id: params[:master_day_id])

    @scheduled.delete_all

    remove_alert_item("Schedule Conflict", params[:student_id], "Student", nil, nil)



    respond_to do |format|
      format.html { redirect_to student_path(params[:student_id])  + "#tab_schedule", notice: 'Schedule Updated' }

    end
  end

  def create_schedule_student_index
    @slot_students = SlotScheduleStudent.new
    @slot_students.slot_schedule_id=params[:slot_schedule_student][:slot_schedule_id]
    @slot_students.student_id=params[:slot_schedule_student][:student_id]

    @student = Student.find(params[:slot_schedule_student][:student_id])
    @slot_schedule = SlotSchedule.find(params[:slot_schedule_student][:slot_schedule_id])

    if @slot_schedule.sub_subject.is_tutorial? 
      @slot_students.associated_group_type="TutorGroup"
      @slot_students.associated_group_id = @student.show_tutor_group_id(session[:global_academic_session])
    else
      @slot_students.associated_group_type="LearningGroup"
      @slot_students.associated_group_id = @student.show_learning_group_id(session[:global_academic_session])
    end

    # @slot_students.associated_group_id=0
    # @slot_students.associated_group_type="LearningGroup"
    
    @slot_students.slot_id=params[:slot_schedule_student][:slot_id]
    @slot_students.term_id=params[:slot_schedule_student][:term_id]
    @slot_students.master_day_id=params[:slot_schedule_student][:master_day_id]
    @slot_students.save

    respond_to do |format|
      format.html { redirect_to student_path(params[:slot_schedule_student][:student_id])  + "#tab_schedule", notice: 'Student was successfully scheduled.' }

    end

  end

  def add_medical_info
   @student=Student.find(params[:student_id])
   @student.student_important_infos.build

    respond_to do |format|

      format.js {render '/students/js/add_medical_info'}

    end
  end

  def create_information
 

@student=Student.find(params[:student_id])
@student.update(info_params)
respond_to do |format|

      format.html { redirect_to student_path(@student), notice: 'Important information was successfully saved.' }

    end
    
  end

  def update_medicalinfo
      @student=Student.find(params[:student_id])
       respond_to do |format|

      format.js {render '/students/js/update_medicalinfo'}

    end
  end

  def save_medical_information
          @student=Student.find(params[:student_id])
          @student.medical_information=params[:student][:medical_information]
          @student.save

    respond_to do |format|

      format.html { redirect_to student_path(@student) + "#tab_info", notice: 'Information was successfully updated.' }

    end
    
  end

  def reactivate_student
  
          @reactivate_student=Student.with_deleted.find(params[:student_id])
          @reactivate_student.deleted_at=nil
          @reactivate_student.save
         
         # @students=Student.only_deleted
         # @student = Student.new
         # @years = MasterGrade.all
         # @deactivate = true
          respond_to do |format|

          format.html {redirect_to students_path(view: "Deactive"), notice: @reactivate_student.name + " was successfully reactivated" }

         end
  end

  def show_caspa_selection

    @caspa_students = Student.with_deleted.order(:fname)
    @academic_years = AcademicSession.all

    respond_to do |format|
      format.js {render '/students/js/show_caspa_selection'}
    end
    
  end

  def export_caspa_data
      # s1 get student list and year ranges from selection

      @students = Student.with_deleted.where(id: params[:student_id])
      year = AcademicSession.find(params[:academic_year])

      # s2 parse years and find caspa p level data for each year and subjects per student

          @file_hash = SecureRandom.hex[0..8]
        
          spreadsheet_name = "ARR-CASPA-#{year.name}-#{@file_hash}.xls"
          last_term_of_ay = year.terms.last
          ay_start_date = year.terms.first.start_date
          ay_end_date = year.terms.last.end_date

          book = Spreadsheet::Workbook.new 
          sheet1 = book.create_worksheet :name => spreadsheet_name

          # create header row
          header_index = 4

          header_row = sheet1.row(0)
          header_row[0] = "Unique Pupil Number (UPN)"
          header_row[1] = "Forename"
          header_row[2] = "Surname"
          header_row[3] = "Cognition and Learning Needs (CLN)"

          subject_id_order = []

          # find all subjects available in that academic year
          core_subjects = Subject.with_deleted.where("is_core = ? AND (deleted_at IS NULL OR deleted_at >= ?) AND created_at <= ?", true, ay_end_date, ay_end_date)
          core_subjects.each do |subject|
              header_row[header_index] = subject.name           # set subject name header
              subject_id_order << subject.id                    # remember order of subjects for data below
              header_index += 1
              
          end

          # do subject id ordering
          row_index = 1
          @students.each do |student|
              report = Report.where(student_id: student.id, academic_session_id: year.id, report_type: "EOY", term_id: last_term_of_ay.id)

              col_index = 4
              
              if !report.blank?
                  row = sheet1.row(row_index)
                  row[0] = student.upn_no
                  row[1] = student.fname
                  row[2] = student.lname
                  row[3] = student.annual_grade_students.joins(:annual_grade).where("annual_grades.academic_session_id = ?",year).first.is_pfc ? "PMLD" : "SLD"

                  r_core_subjects = report.first.report_core_subjects
                  ordered_r_core_subjects = []

                  subject_id_order.each_with_index do |id, idx|
                    found_idx = r_core_subjects.find_index{|c| c.subject_id == id}
                    if found_idx != nil
                      ordered_r_core_subjects << r_core_subjects[found_idx]
                    else
                      ordered_r_core_subjects << nil
                    end
                  end 

                  ordered_r_core_subjects.each do |core|
                      row[col_index] =  core != nil ? !(core.p_level.nil? || core.p_sub_level.nil?) ? (core.p_level + core.p_sub_level).split.join : "Incomplete" : "Unavailable"
                      col_index += 1
                  end
              end

              row_index += 1

          end
    
          # s3 send file to user
          xls_directory = 'public/caspa'
          Dir.mkdir(xls_directory) unless File.exists?(xls_directory)  

          export_file_path = Rails.root.join(xls_directory, spreadsheet_name)
          book.write export_file_path
          
          @dl_file
          t = Thread.new { @dl_file = open(export_file_path) }
          t.join 

          send_data @dl_file.read, :filename => spreadsheet_name,  :disposition => 'attachment', :x_sendfile => true

  end

def add_summary
  if params[:summary_user]
    @summary_user = params[:summary_user].to_i
  end
    @master_csd_axis = MasterCsdAxis.all

  @t_summary_user = @summary_user.blank? ? current_user.id : @summary_user 

  @term = Term.find(session[:global_current_term])
  @term_year =  @term.master_term.display_name +  " " + @term.academic_session.name

  @student=Student.find(params[:student_id])
  @student_lo = StudentLearningObjective.find(params[:lo])
  @student_lo_observations = @student_lo.observations
     
  @student_learning_objective_observation= StudentLearningObjectiveObservation.find_or_initialize_by(student_learning_objective_id: @student_lo, user_id: @t_summary_user, academic_session_id: session[:global_academic_session], term_id: session[:global_current_term], is_summary: true)
  @summary = SummaryLearningObjective.pluck(:original_obs_id)
   respond_to do |format|
    format.js{render '/students/js/add_summary'}
    end
end

def save_lo_summary
 
  # user for edit from student show and observation show edit
if !params[:student_learning_objective_observation][:summary_user].blank?
  user = params[:student_learning_objective_observation][:summary_user].to_i
else
  user = current_user.id
end

  @lo = StudentLearningObjective.find(params[:student_learning_objective_observation][:student_learning_objective_id])
  
  @summary_obs = StudentLearningObjectiveObservation.find_or_initialize_by(student_learning_objective_id: @lo.id, is_summary: true, user_id: user, term_id: session[:global_current_term], academic_session_id: session[:global_academic_session] )

  @summary_obs.student_learning_objective_id  = @lo.id
  @summary_obs.date = Time.now# date from modal

  @summary_obs.description = params[:summary]
  @summary_obs.summary_subject_name = params[:classes]
  @summary_obs.save


  incoming_obs = []

  existing_obs = SummaryLearningObjective.where(summary_obs_id: @summary_obs.id).pluck("original_obs_id")

  if params[:check_ids]
    incoming_obs = params[:check_ids].collect{|a| a.to_i}
  end

  deleted_obs = existing_obs - incoming_obs
  new_obs = incoming_obs - existing_obs

  if new_obs.present?
    new_obs.each_with_index do |(key,value),index|

      @summary_asso = SummaryLearningObjective.find_or_create_by(summary_obs_id: @summary_obs.id, original_obs_id: key.to_i)

        @student_observation = StudentLearningObjectiveObservation.find(key.to_i)
          StudentLearningObjectiveObservationFile.where(student_learning_objective_observation_id: key).each do |evidence|
          @file = StudentLearningObjectiveObservationFile.new
          @file.student_learning_objective_observation_id = @summary_obs.id 
          @file.original_obs_id = @student_observation.id 
          @file.evidence = evidence.evidence
          @file.save
        end
    end
  end
     #121925577 
   if params[:master_axis_id].present?
      params[:master_axis_id].each_with_index do |master_axis_id, index|
        @summary_lo = SummaryLearningObjectiveAchievement.find_or_initialize_by(student_learning_objective_observation_id: @summary_obs.id,master_csd_axis_id: master_axis_id)
        @summary_lo.student_learning_objective_observation_id = @summary_obs.id
        @summary_lo.master_csd_axis_id = master_axis_id
        @summary_lo.achievement_value = params[:targetaxisvalue][index]
        @summary_lo.save
      end
    end
    # end
  # TODO check 
  deleted_obs.collect{|id| StudentLearningObjectiveObservationFile.where(original_obs_id: id).destroy_all}
  deleted_obs.collect{|id| SummaryLearningObjective.where(summary_obs_id: @summary_obs.id, original_obs_id: id).destroy_all}
@summary_obs.update(files_params)
  flash[:notice] = "The summary has been updated."
  redirect_to :back
end


# print
def print_student_lo
  
  @student = Student.find(params[:id])
      @master_csd_axis = MasterCsdAxis.all
 @current = []
    @closed = [] 
    @completed = []
    if params[:current_lo]=="1"
      @current_lo=1
      @current=@student.student_learning_objectives.where("is_closed = ? AND is_completed = ?", false, false) 
    end

    if params[:closed_lo]=="1"
      @closed_lo=1
      @closed=@student.student_learning_objectives.where("is_closed = ?" , true)
    end

    if params[:completed_lo]=="1"
      @completed_lo=1
      @completed=@student.student_learning_objectives.where("is_completed = ?", true)

    end

    @temp_learning_objectives = @current + @closed + @completed

    @ordered_rfl = @temp_learning_objectives.find_all{|a| a.global_lo_type=="GlobalRflObjective"}.sort_by{|a| [a.global_lo.position, a.assigned_date, a.id] }
    # @ordered_pivats = @temp_learning_objectives.find_all{|a| a.global_lo_type=="GlobalPivatsSublevel"}.sort_by{|a| [a.global_lo.sub_subject.subject.position, a.global_lo.sub_subject.position, a.assigned_date, a.id] }
    @ordered_pivats = @temp_learning_objectives.find_all{|a| a.global_lo_type=="GlobalPivatsSublevel"}.sort_by{|a| [a.global_lo.global_pivats_objective.sub_subject.subject.position, a.global_lo.global_pivats_objective.sub_subject.position, a.assigned_date, a.id] }
    @ordered_custom = @temp_learning_objectives.find_all{|a| a.global_lo_type=="GlobalCustomObjective"}.sort_by{|a| [a.assigned_date, a.id] }


    @student_learning_objectives = @ordered_rfl + @ordered_pivats + @ordered_custom

   
    # Schedule fields

    @selected_academic_session = session[:global_academic_session]
    @selected_student = params[:id]

    @academic_sessions = AcademicSession.all.order("id DESC")

    @master_days = MasterDay.all
    @slots = Slot.where(academic_session_id: @selected_academic_session, is_taught_time: true)


    @term=Term.find(session[:global_current_term])
    @slot_schedules = @student.slot_schedules.where(term_id: @term.id)

    @has_schedule = @slot_schedules.blank? ? false : true
   

   
 # respond_to do |format|
    render '/students/print/_print_student_lo'
    # end
  # render  '/students/print/_print_student_lo'
  
end
def add_student_profile

  @student_profile_new = StudentProfile.new 
@student=Student.find(params[:student_id])
@student_profile = @student.student_profiles.where(student_id: @student)

if @student_profile.present?

  puts "present"
else

puts "not present"
end
       respond_to do |format|

      format.js {render '/students/js/add_student_profile_data'}

    end

  end
def save_profile_data

  if params[:profile_id].present?
    @student=StudentProfile.find(params[:profile_id])
    @profilestudent = @student.student_id
    
          @student.heading1=params[:student_profile][:heading1]
          @student.heading2=params[:student_profile][:heading2]
          @student.heading3=params[:student_profile][:heading3]
          @student.heading4=params[:student_profile][:heading4]
          @student.save

   else
          @student_profile_new = StudentProfile.new  
          @student_profile_new.student_id= params[:student_id]
          @student_profile_new.heading1= params[:student_profile][:heading1]
          @student_profile_new.heading2= params[:student_profile][:heading2]
          @student_profile_new.heading3= params[:student_profile][:heading3]
          @student_profile_new.heading4= params[:student_profile][:heading4]
          @profilestudent = params[:student_id]
          @student_profile_new.save

    end

    respond_to do |format|

      format.html { redirect_to student_path(@profilestudent) + "#tab_student_profile", notice: 'Profile was successfully updated.' }

    end
  
end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.with_deleted.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def student_params
    params[:student].permit(:fname,:lname,:sex,:dob,:asdan_no,:upn_no,:medical_information,:description,:avatar)
  end
  def info_params
    params[:student].permit(student_important_infos_attributes:
      [:id ,:student_id,:user_id,:description,:_destroy
      ]
      )
  end
def files_params
    params.require(:student_learning_objective_observation).permit(student_learning_objective_observation_files_attributes: [:id,:evidence,:_destroy])

  end

end
