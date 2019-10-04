class ObservationsController < ApplicationController
  before_action :set_observation, only: [:show, :edit, :update, :destroy]

  # GET /observations
  # GET /observations.json
  def index
    @observations = Observation.all  
  end

  # GET /observations/1
  # GET /observations/1.json
  def show
  end

  # GET /observations/new
  def new
    @observation = Observation.new
  end

  # GET /observations/1/edit
  def edit
  end

  # POST /observations
  # POST /observations.json
  def create
    @observation = Observation.new(observation_params)

    respond_to do |format|
      if @observation.save
        format.html { redirect_to @observation, notice: 'Observation for the LO was successfully created.' }
        format.json { render :show, status: :created, location: @observation }
      else
        format.html { render :new }
        format.json { render json: @observation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /observations/1
  # PATCH/PUT /observations/1.json
  def update
    respond_to do |format|
      if @observation.update(observation_params)
        format.html { redirect_to @observation, notice: 'Observation for the LO was successfully updated.' }
        format.json { render :show, status: :ok, location: @observation }
      else
        format.html { render :edit }
        format.json { render json: @observation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /observations/1
  # DELETE /observations/1.json
  def destroy
    @observation.destroy
    respond_to do |format|
      format.html { redirect_to observations_url, notice: 'Observation for the LO was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  # custom methods
  def add_observation

    @student=Student.find(params[:student_id])
    # @student_slot_schedule=@student.slot_schedules.where(:academic_session_id=> session[:global_academic_session])
    @student_slot_schedule = @student.slot_schedules.where(academic_session_id: session[:global_academic_session], term_id: session[:global_current_term], user_id: current_user.id).pluck(:sub_subject_id).uniq.collect{|u| [SubSubject.with_deleted.find(u).show_name, u]}
    @student_learning_objective_observation=StudentLearningObjectiveObservation.new

    @student_learning_objective_observation.student_learning_objective_observation_files.build
  # student_learning_objective_observation_files=StudentLearningObjectiveObservationFile.new
  # @subjects=Subject.where(is_pivats: false, is_core: false, is_ppa: false)

  @student_lo=StudentLearningObjective.find_by(:id =>params[:lo])
  respond_to do |format|
    if  params[:staff]=="true"

    format.js {render '/observations/js/add_observation_staff'}
    else
    format.js {render '/observations/js/add_observation'}
  end
  end

  end

  def save_observation

    @student_learning_objective_observation=StudentLearningObjectiveObservation.new(student_learning_objective_observation_params)
    @student_learning_objective_observation.user_id=current_user.id
    @student_learning_objective_observation.term_id =session[:global_current_term]
    @student_learning_objective_observation.academic_session_id=session[:global_academic_session]

    if @student_learning_objective_observation.save 
      if params[:evidences] 

        params[:evidences].collect do |file|
          @evidence=StudentLearningObjectiveObservationFile.new
          @evidence.student_learning_objective_observation_id= @student_learning_objective_observation.id
          @evidence.evidence=file
          @evidence.save
        end
      end
      remove_alert_item("Learning Objective Inactivity", nil, nil, @student_learning_objective_observation.student_learning_objective.id, "StudentLearningObjective")
    end

    redirect_to :back
  end
  # end

  def view_observation

    @student=Student.with_deleted.find(params[:student_id])

    @master_csd_axis = MasterCsdAxis.all
    @student_learning_objectives=StudentLearningObjective.find_by(:id =>params[:lo])
  # @student=@student_learning_objectives.student
  @student_lo_observation= @student_learning_objectives.observations
  # summary
@term = Term.find(session[:global_current_term])
@term_year =  @term.master_term.display_name +  " " + @term.academic_session.name
# @student_lo = StudentLearningObjective.find(params[:lo])
# @student_lo_observations = @student_lo.observations
@student_learning_objective_observation= StudentLearningObjectiveObservation.find_or_initialize_by(student_learning_objective_id: @student_lo,is_summary: true)
@summary = SummaryLearningObjective.pluck(:original_obs_id)

  respond_to do |format|
    format.js {render '/observations/js/view_observation'}
  end

  end
  def view_observation_staff

    @student=Student.find(params[:student_id])
    @master_csd_axis = MasterCsdAxis.all
    @student_learning_objectives=StudentLearningObjective.find_by(:id =>params[:lo])

    @student_lo_observation= @student_learning_objectives.observations
    respond_to do |format|
      format.js {render '/observations/js/view_observation_staff'}
    end

  end


  def edit_observation  


    @student=Student.find(params[:student_id])
    # @student_slot_schedule=@student.slot_schedules.where(:academic_session_id=> session[:global_academic_session])
    if current_user.is_team_lead?
      @student_slot_schedule = @student.slot_schedules.where(academic_session_id: session[:global_academic_session], term_id: session[:global_current_term]).pluck(:sub_subject_id).uniq.collect{|u| [SubSubject.find(u).show_name, u]}
    else
      @student_slot_schedule = @student.slot_schedules.where(academic_session_id: session[:global_academic_session], term_id: session[:global_current_term], user_id: current_user.id).pluck(:sub_subject_id).uniq.collect{|u| [SubSubject.find(u).show_name, u]}
    end
  # @subjects=Subject.where(is_pivats: false, is_core: false, is_ppa: false)

  @observation=StudentLearningObjectiveObservation.find_by(:id=>params[:id])
  @student_lo = @student.student_learning_objectives.all
  respond_to do |format|
    format.js {render '/observations/js/edit_observation'}
  end

  end

  def save_edit_observation




   
    @observation= StudentLearningObjectiveObservation.find(params[:id])

    # if @observation.student_learning_objective_observation_files.present?
    #   @observation.student_learning_objective_observation_files.where(:file_flag=>true).collect do |flag|
    #     flag.destroy
    #   end
    # end

    @observation.update(student_learning_objective_observation_params)
    if @observation.save
      @student= @observation.student_learning_objective.student
      if params[:evidences]
        params[:evidences].collect do |file|
          @evidence=StudentLearningObjectiveObservationFile.new
          @evidence.student_learning_objective_observation_id= @observation.id
          @evidence.evidence=file
          @evidence.save
        end
      end

      @student_learning_objectives=@observation.student_learning_objective
      @student_lo_observation= @student_learning_objectives.observations
      @master_csd_axis = MasterCsdAxis.all
      if params[:a]

        respond_to do |format|
          format.html {redirect_to :back}
          format.js {render '/observations/js/save_edit_observation_from_staff'}
        end
      else
        respond_to do |format|
          format.html {redirect_to :back}
          format.js {render '/observations/js/save_edit_observation'}
        end
      end
    end
  end
  def delete_observation
    @student_learning_objectives=StudentLearningObjective.find(params[:student_lo_id])
    @student=@student_learning_objectives.student
    @master_csd_axis = MasterCsdAxis.all
  # @subjects=Subject.where(is_pivats: false, is_core: false, is_ppa: false)

  @observation=StudentLearningObjectiveObservation.find_by(:id=>params[:id])
  @student_lo_observation=@observation.student_learning_objective.observations

  if @observation.student_learning_objective_observation_files.present?
    @observation.student_learning_objective_observation_files.destroy_all
  end
  @observation.destroy
  respond_to do |format|
    format.js {render '/observations/js/delete_observation'}
  end

  end

  def change_file_flag
    # @subjects=Subject.where(is_pivats: false, is_core: false, is_ppa: false)

    @file=StudentLearningObjectiveObservationFile.find_by(:id=>params[:file_id])
    @file.file_flag=true
    @file.save
    # @observation=StudentLearningObjectiveObservation.find_by(:id=>params[:observe_id])
render nothing: true
    # respond_to do |format|
    #   format.js {render '/observations/js/change_file_flag'}
    # end
  end


  def show_evidence_from_modal

    @file=StudentLearningObjectiveObservationFile.find(params[:file_id])


    respond_to do |format|
      format.js {render '/observations/js/show_evidence_from_modal'}
    end
  end

def show_individual_evidence
  @file=StudentLearningObjectiveObservationFile.find(params[:file_id])


    respond_to do |format|
      format.js {render '/observations/js/individual_evidence'}
    end
  
end

  def hide_image_observation
    respond_to do |format|
      format.js {render '/observations/js/hide_image_observation'}
    end
  end

  def edit_observation_from_staff

    @student=Student.find(params[:student_id])

    if current_user.is_team_lead?
      @student_slot_schedule = @student.slot_schedules.where(academic_session_id: session[:global_academic_session], term_id: session[:global_current_term]).pluck(:sub_subject_id).uniq.collect{|u| [SubSubject.find(u).show_name, u]}
    else
      @student_slot_schedule = @student.slot_schedules.where(academic_session_id: session[:global_academic_session], term_id: session[:global_current_term], user_id: current_user.id).pluck(:sub_subject_id).uniq.collect{|u| [SubSubject.find(u).show_name, u]}
    end

    # @student_slot_schedule = @student.slot_schedules.where(:academic_session_id=> session[:global_academic_session]).pluck(:sub_subject_id).uniq.collect{|u| [SubSubject.find(u).show_name, u]}
    # @student_slot_schedule=@student.slot_schedules.where(:academic_session_id=> session[:global_academic_session])
  # @subjects=Subject.where(is_pivats: false, is_core: false, is_ppa: false)

  @observation=StudentLearningObjectiveObservation.find_by(:id=>params[:id])
  respond_to do |format|
    format.js {render '/observations/js/edit_observation_from_staff'}
  end
  end

  def delete_observation_from_staff
    @student_learning_objectives=StudentLearningObjective.find(params[:student_lo_id])
    @master_csd_axis = MasterCsdAxis.all
    @subjects=Subject.where(is_pivats: false, is_core: false, is_ppa: false)
    @observation=StudentLearningObjectiveObservation.find_by(:id=>params[:id])
    @student_learning_objectives=@observation.student_learning_objective

    @student_lo_observation=@observation.student_learning_objective.observations

    if @observation.student_learning_objective_observation_files.present?
      @observation.student_learning_objective_observation_files.destroy
    end
    @observation.destroy
    respond_to do |format|
      format.js {render '/observations/js/delete_observation_from_staff'}
    end

  end



  # student_card
  def add_observation_student_card


    @student=Student.find(params[:student_id])  

    @student_slot_schedule = @student.slot_schedules.where(academic_session_id: session[:global_academic_session], term_id: session[:global_current_term], user_id: current_user.id).pluck(:sub_subject_id).uniq.collect{|u| [SubSubject.find(u).show_name, u]}    
    
    @student_learning_objective_observation=StudentLearningObjectiveObservation.new

    @student_learning_objective_observation.student_learning_objective_observation_files.build

    # @subjects=Subject.where(is_pivats: false, is_core: false, is_ppa: false)

    @student_lo = @student.student_learning_objectives.where(is_completed: false, is_closed: false)
   # @loc_mark = @student.student_learning_objectives.where(is_completed: false, is_closed: false).pluck(:id).first
    
    # preset auto-selectable values to nil  
    @selected_sub_subject_id = nil
    @selected_lo_id = nil

    # find current timeline slot and select the class running presently
    if !@timeline_selected_slot.blank?

      timeline_selected_schedule = @timeline_selected_slot.slot_schedules.find_by(academic_session_id: @timeline_selected_academic_session_id, term_id: @timeline_selected_term_id, master_day_id: @timeline_selected_master_day_id, user_id: current_user.id)

      if !timeline_selected_schedule.blank? 
        @selected_sub_subject_id = timeline_selected_schedule.sub_subject_id       
        selected_lo_focus = @student.student_learning_objectives.map(&:focus_classes).flatten.collect{|a| (a.user_id == current_user.id && a.academic_session_id == session[:global_academic_session] && a.term_id == session[:global_current_term] && a.sub_subject_id == timeline_selected_schedule.sub_subject_id) ? a : nil }.compact.first
        @selected_lo_id = !selected_lo_focus.blank? ? selected_lo_focus.student_learning_objective_id : nil

      end

    end

    respond_to do |format|
      format.js {render '/observations/js/add_observation_student_card'}

    end
  
end



  def save_only_evidence

  @student_learning_objective_observation=StudentLearningObjectiveObservation.new
  @student_learning_objective_observation.user_id=current_user.id
  @student_learning_objective_observation.term_id =session[:global_current_term]
  @student_learning_objective_observation.academic_session_id=session[:global_academic_session]
  @student_learning_objective_observation.date=Time.now
  @student_learning_objective_observation.student_id=params[:student_id]

  @student_learning_objective_observation.save 
 

   #puts "#{key}"
  

  puts params[:student_id]
  params[:Attachment].each do |key,value|
  @evidence=StudentLearningObjectiveObservationFile.new
  @evidence.student_learning_objective_observation_id= @student_learning_objective_observation.id
  @evidence.evidence= params[:Attachment]["#{key}"]
  @evidence.save
 end
  respond_to do |format|
      format.js {render '/observations/js/save_only_evidence'}

    end
  end

def assign_individual_observation
  @observation=StudentLearningObjectiveObservation.find(params[:observation_id])
    @student=Student.find(params[:student_id])

    if current_user.is_team_lead?
      @student_slot_schedule = @student.slot_schedules.where(academic_session_id: session[:global_academic_session], term_id: session[:global_current_term]).pluck(:sub_subject_id).uniq.collect{|u| [SubSubject.find(u).show_name, u]}
    else
      @student_slot_schedule = @student.slot_schedules.where(academic_session_id: session[:global_academic_session], term_id: session[:global_current_term], user_id: current_user.id).pluck(:sub_subject_id).uniq.collect{|u| [SubSubject.find(u).show_name, u]}
    end
    # @student_slot_schedule=@student.slot_schedules.where(:academic_session_id=> session[:global_academic_session])
    # @student_slot_schedule = @student.slot_schedules.where(:academic_session_id=> session[:global_academic_session]).pluck(:sub_subject_id).uniq.collect{|u| [SubSubject.find(u).show_name, u]}
    @student_lo=@student.student_learning_objectives
   @student_learning_objective_observation=StudentLearningObjectiveObservation.new

    @student_learning_objective_observation.student_learning_objective_observation_files.build
  respond_to do |format|
    format.js {render '/observations/js/assign_individual_observation'}

    end
end
def assign_observation

      @observation= StudentLearningObjectiveObservation.find(params[:id])
@observation.student_learning_objective_id=params[:student_learning_objective_observation][:student_learning_objective_id]
@observation.sub_subject_id=params[:student_learning_objective_observation][:sub_subject_id]
@observation.description=params[:student_learning_objective_observation][:description]
@observation.date=params[:student_learning_objective_observation][:date]

    if @observation.student_learning_objective_observation_files.present?
      @observation.student_learning_objective_observation_files.where(:file_flag=>true).collect do |flag|
        flag.destroy
      end
    end
@observation.save

 respond_to do |format|
      format.html { redirect_to student_path(@observation.student.id)  + "#tab_individual_observation", notice: 'Observation was successfully assigned to the LO.' }

    end
end


def delete_individual_observation
  
   @observation=StudentLearningObjectiveObservation.find_by(:id=>params[:observation_id])
  if @observation.student_learning_objective_observation_files.present?
    @observation.student_learning_objective_observation_files.destroy_all
  end

@observation.destroy

 respond_to do |format|
      format.html { redirect_to student_path(params[:student_id])  + "#tab_individual_observation", notice: ' Observation was successfully deleted.' }

    end
end

def download

   @evidence = StudentLearningObjectiveObservationFile.find(params[:id])

    @doc_url=@evidence.evidence.path
   
    @doc_data
    t = Thread.new { @doc_data = open(@doc_url) }
    t.join 
 
    send_data @doc_data.read, :filename => @evidence.evidence_file_name,  :disposition => 'attachment', :x_sendfile => true

end


def XXXadd_term_obs
 StudentLearningObjectiveObservation.all.each do |a|
 a.term_id =  session[:global_current_term]
 a.academic_session_id = session[:global_academic_session]
a.save
end
  
end
  # end
  private
  # Use callbacks to share common setup or constraints between actions.
  # def set_observation
  #   @observation = Observation.find(params[:id])
  # end

  # Never trust parameters from the scary internet, only allow the white list through.
  # def observation_params
  #   params[:observation]
  # end
  def student_learning_objective_observation_params
    params.require(:student_learning_objective_observation).permit(:user_id,:student_learning_objective_id,:sub_subject_id,:date,:description,student_learning_objective_observation_files_attributes: [:id,:evidence,:_destroy])

  end
end
