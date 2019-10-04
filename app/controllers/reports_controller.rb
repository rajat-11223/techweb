class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
 skip_before_action :authenticate_user!, :only => :overall
 skip_before_action :authenticate_user!, :only => :report_play_video
  #skip_authorize_resource :only => :overall
  # GET /reports
  # GET /reports.json

 # Report page for parents
  def student_report

    @report = Report.find_by_slug(params[:id])
    @student =  @report.student
    @report_learning_objectives = @report.report_objectives
    @report_core_subjects = @report.report_core_subjects
    @master_csd_axis = MasterCsdAxis.all
    @p_level =MasterPLevel.pluck(:name)
    @p_sublevel = MasterPSubLevel.pluck(:name)

    @report_subjects = @report.report_subjects
    @evidence_positions = @report.report_objectives.joins(:report_observation_evidences).pluck("report_observation_evidences.position")
  
   render layout: "parent_layout"
  end

 #send report link to parents through mail
 def send_report_parents
    @report = Report.find(params[:rs_id])
    @student = @report.student
    @recipient = params[:to]
    @subject = params[:Subject]
    @desc = params[:desc]
     #Report.where(:id=> params[:report_id]).update_attribute(:slug=> @newslug)
    Resque.enqueue(ReportAlert,@student.id,@report.id,@recipient,@subject,@desc,action_name,current_user.id)
    respond_to do |format|
     #flash[:notice] ="Report successfully sent to parents"
      format.html { redirect_to report_path(@report), notice: 'Report successfully sent to parents' }
      #format.html{redirect_to report_path(id: @report.id)}
    end
 end


#show popup model for sending email to parents
 def report_send_parent

    @rep = Report.find(params[:report_id])   
    respond_to do |format|
      format.js {render 'reports/js/report_send_parents'}
    end
 end

def index

    if params[:view]

      case params[:view]

      when "all"

        calculate_ranges
        @view = "all"


        if params[:students] == "Deactive Students"

          @deactive = true
          @students = Student.only_deleted.order("lname ASC")
          @reports = Report.where("student_id IN (?) AND academic_session_id IN (?)", @students.pluck(:id).map{|id| id.to_s}, @find_range)

          # @reports = @students.map(&:reports).reject!(&:empty?)

        else
          @students = Student.all.order("lname ASC")
          @reports = Report.where("student_id IN (?) AND academic_session_id IN (?)", @students.pluck(:id).map{|id| id.to_s}, @find_range)

          # @reports = @students.map(&:reports).reject!(&:empty?)
        end

      when "by_tutor_group"

        calculate_ranges

        @view = "by_tutor_group"

        @students = current_user.get_tutor_group(session[:global_academic_session]).students.order("lname ASC")
        # @reports = @students.map(&:reports).reject!(&:empty?)
        @reports = Report.where("student_id IN (?) AND academic_session_id IN (?)", @students.pluck(:id).map{|id| id.to_s}, @find_range)

      when "by_phase"

        calculate_ranges

        @view = "by_phase"


        if current_user.is_team_lead? && current_user.lead_phase_id(session[:global_academic_session]) != 0

          @students = current_user.phases.where("academic_session_id = ?", session[:global_academic_session]).last.students
          @reports = Report.where("student_id IN (?) AND academic_session_id IN (?)", @students.pluck(:id).map{|id| id.to_s}, @find_range)

        end

        # if current_user.is_team_lead? && current_user.lead_phase_id(session[:global_academic_session]) != 0

        # @students = current_user.get_tutor_group(session[:global_academic_session]).students.order("lname ASC")
        # @reports = @students.map(&:reports).reject!(&:empty?)
        # @reports = Report.where("student_id IN (?) AND academic_session_id IN (?)", @students.pluck(:id).map{|id| id.to_s}, @find_range)

      when "by_class" # check if needed, makes less sense

        @view = "by_class"

        temp_exempt_subjects = Subject.where("subjects.is_lunch = true OR subjects.is_tutorial = true OR subjects.is_ppa = true").joins(:sub_subjects).pluck("sub_subjects.id")
        @uniq_subjects = current_user.slot_schedules.order(term_id: :desc).where("academic_session_id = ? AND sub_subject_id NOT IN (select sub_subjects.id from sub_subjects INNER JOIN subjects ON subjects.id = sub_subjects.subject_id WHERE subjects.is_lunch = true OR subjects.is_tutorial = true OR subjects.is_ppa = true)", session[:global_academic_session]).pluck(:sub_subject_id, :term_id, :learning_group_id).uniq

      else

        render :status => 404, :formats => [:html]

      end

    else

      calculate_ranges
      @view = "all"

      if params[:students] == "Deactive Students"
        @deactive = true
        @students = Student.only_deleted.order("lname ASC")
        @reports = Report.where("student_id IN (?) AND academic_session_id IN (?)", @students.pluck(:id).map{|id| id.to_s}, @find_range)

        # @reports = @students.map(&:reports).reject!(&:empty?)

      else
        @students = Student.all.order("lname ASC")
        @reports = Report.where("student_id IN (?) AND academic_session_id IN (?)", @students.pluck(:id).map{|id| id.to_s}, @find_range)

        # @reports = @students.map(&:reports).reject!(&:empty?)
      end

    end

end 
  # GET /reports/1
  # GET /reports/1.json
def show
    @report = Report.find(params[:id])
    @student =  @report.student
    @report_learning_objectives = @report.report_objectives
    @report_core_subjects = @report.report_core_subjects
    @master_csd_axis = MasterCsdAxis.all
    @p_level =MasterPLevel.pluck(:name)
    @p_sublevel = MasterPSubLevel.pluck(:name)

    @report_subjects = @report.report_subjects

    if !@report.slug.present?
  @newslug = SecureRandom.urlsafe_base64(6)
  Report.where(:id=> params[:id]).update_all(:slug=> @newslug)
    end

    @evidence_positions = @report.report_objectives.joins(:report_observation_evidences).pluck("report_observation_evidences.position")
    @report_subjects = @report.report_subjects
    #Report.create! title: "Joe Schmoe"
end

  # GET /reports/new
  def new

    @report = Report.new
    @student=Student.find(params[:student_id])
    @student_learning_objectives=@student.student_learning_objectives
    @master_csd_axis = MasterCsdAxis.all

  end

  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])
    @student = Student.find(params[:student_id])
    @report_learning_objectives = @report.report_objectives
    @report_core_subjects = @report.report_core_subjects.joins(:subject).order("subjects.name ASC")
    @master_csd_axis = MasterCsdAxis.all
    @p_level =MasterPLevel.pluck(:name)
    @p_sublevel = MasterPSubLevel.pluck(:name)

    @report_subjects = @report.report_subjects

    @evidence_positions = @report.report_objectives.joins(:report_observation_evidences).pluck("report_observation_evidences.position")
    @report_subjects = @report.report_subjects
    # status check start
    # TODO check conditions

    # begin 121925395  * not needed
    # current_term_id = session[:global_current_term]
    # current_term_ay_id = session[:global_academic_session]

    # previous_term_id = current_term_id - 1
    # previous_term_ay_id =  Term.where(id: previous_term_id).blank? ? current_term_ay_id : Term.where(id: previous_term_id).first.academic_session_id
    # end 121925395
    # change report tutor if user was changed
    if params[:tutor_changed] == 'true'
      new_user_id = @report.student.tutor_groups.where(academic_session_id: @report.academic_session_id).last.try(:user_id)
      if new_user_id
        @report.update(tutor_id: new_user_id)
      end
    end

    if @report.status == "IP"

      report_objective_id  = @report.report_objectives.pluck(:student_learning_objective_id)
      student_objective_id = @student.student_learning_objectives.where("(is_completed = false AND is_closed = false AND term_id <= ?)  OR (is_completed = true AND achieved_date >= ? AND achieved_date <= ?)", @report.term_id, Term.find(@report.term_id).start_date, Term.find(@report.term_id).end_date).pluck(:id)
      new_lo      =  student_objective_id - report_objective_id
      deleted_lo  = report_objective_id - student_objective_id
      existing_lo = report_objective_id
      if new_lo
        new_lo.each do |key,value|
          @student_lo  = StudentLearningObjective.find(key)
          @report_objective=ReportObjective.new
          @report_objective.report_id = @report.id
          @report_objective.student_learning_objective_id = key
          @report_objective.subject_id =    @student_lo .subject_id
          @report_objective.sub_subject_id = @student_lo.sub_subject_id
          @report_objective.p_level = @student_lo.p_level
          @report_objective.assigned_date = @student_lo.assigned_date
          @report_objective.target_date = @student_lo.target_date

          # begin 121925395 * not needed
          # if previous_term_id != 0
          #   temp_ob = Report.find_by(term_id: previous_term_id,student_id: @student.id).report_objectives
          #   if temp_ob.collect {|a| a.student_learning_objective_id}.include? @student_lo.id
          #     p_report_lo = temp_ob.select{ |a| a.student_learning_objective_id == @student_lo.id}.first
          #     @report_objective.lo_status = p_report_lo.lo_status
          #   else
          #     @report_objective.lo_status = Report::REPORT_STATUS[0][1]
          #   end
          # end

          # if @student_lo.is_completed == true && @student_lo.achieved_date < Term.find(@student_lo.term_id).end_date
          #   @report_objective.lo_status = Report::REPORT_STATUS[2][1]
          # end
          # end 121925395

          @report_objective.save

        end
      end

      # delete start
      if deleted_lo
        deleted_lo.each do |lo_id|
          @report_objective = ReportObjective.find_by(student_learning_objective_id: lo_id)
          if @report_objective.report_objective_observations.present?

            @report_objective.report_objective_observations.each do |obs|

              if obs.report_observation_evidences.present?

                obs.report_observation_evidences.destroy_all
              end
              obs.destroy
            end
          end
          @report_objective.destroy
        end
      end
    end
    # status check end
    # update EOY report core subjects in database if any changed
    if @report.status != "AP" && @report.report_type == "EOY"

      report_core_subjects  = @report.report_core_subjects.pluck(:subject_id)
      db_core_subjects = Subject.where("is_core = true").pluck(:id)

      new_rcs      =  db_core_subjects - report_core_subjects
      deleted_rcs  =  report_core_subjects - db_core_subjects
      existing_rcs =  report_core_subjects

      if new_rcs
        new_rcs.each do |key,value|
          @report_core = ReportCoreSubject.new
          @report_core.report_id = @report.id
          @report_core.subject_id = key
          @report_core.save
        end
      end

      if deleted_rcs
        deleted_rcs.each do |key,value|
          @report.report_core_subjects.find_by(subject_id: key).destroy
        end
      end

    end

  end

  # POST /reports
  # POST /reports.json
  def create

    @student=Student.find(params[:student_id])

    build_report = false

    current_term_id = session[:global_current_term]
    current_term_ay_id = session[:global_academic_session]

    previous_term_id = current_term_id - 1
    previous_term_ay_id =  Term.where(id: previous_term_id).blank? ? current_term_ay_id : Term.where(id: previous_term_id).first.academic_session_id

    if previous_term_id != 0
      previous_report_exists = Report.where(student_id: @student.id, term_id: previous_term_id).blank? ? false : true
    else
      previous_report_exists = true
    end

    current_report_exists = Report.where(student_id: @student.id, term_id: current_term_id).blank? ? false : true

    if current_report_exists

      build_report = false

      # Show message that report has already been created. Ask to edit.

    elsif previous_report_exists

      # create report for current term
      @selected_ay_id = current_term_ay_id
      @selected_term_id = current_term_id

      infer_report_variable_values(@selected_term_id, @selected_ay_id)

      build_report = true

    else

      # create report for previous term
      @selected_ay_id = previous_term_ay_id
      @selected_term_id = previous_term_id

      infer_report_variable_values(@selected_term_id, @selected_ay_id)

      build_report = true

    end

    respond_to do |format|

      if build_report

        @report = Report.new
        @newslug = SecureRandom.urlsafe_base64(6)
        @report.slug = @newslug
        @report.academic_session_id = @selected_ay_id
        @report.student_id = @student.id
        @report.term_id = @selected_term_id
        @report.user_id = current_user.id
        @report.tutor_id = !@student.get_tutor_group(@selected_ay_id).blank? ? @student.get_tutor_group(@selected_ay_id).user.id : current_user.id
        @report.title = @report_title
        @report.report_type = @report_type
        @report.status = "IP"
        # @report.phase_name = @student.show_phase
        @report.phase_name = !@student.phase(@selected_ay_id).blank? ? @student.phase(@selected_ay_id).name : ""
        @report.lg_name = @student.show_learning_group_name(@selected_ay_id)

        @report.save

        # ####  change the dates in query to previous term close and next term start.
        # @student_learning_objectives = @student.student_learning_objectives.where("(is_completed = false AND is_closed = false) OR (is_completed = true AND achieved_date >= ? AND achieved_date <= ?) ",Term.find(@selected_term_id).start_date, Term.find(@selected_term_id).end_date)
        @student_learning_objectives = @student.student_learning_objectives.where("(is_completed = false AND is_closed = false AND term_id <= ?)  OR (is_completed = true AND achieved_date >= ? AND achieved_date <= ?) ", @report.term_id, Term.find(@selected_term_id).start_date, Term.find(@selected_term_id).end_date)

        @student_learning_objectives.each do |objective|
          @report_objective=ReportObjective.new
          @report_objective.report_id = @report.id
          @report_objective.student_learning_objective_id = objective.id
          @report_objective.subject_id = objective.subject_id
          @report_objective.sub_subject_id = objective.sub_subject_id
          @report_objective.p_level = objective.p_level
          @report_objective.p_sublevel = objective.p_sublevel
          @report_objective.assigned_date = objective.assigned_date
          @report_objective.target_date = objective.target_date

          # begin cr 121925395
          if previous_term_id != 0

            temp_ob = Report.find_by(term_id: previous_term_id,student_id: @student.id).report_objectives

            if temp_ob.collect {|a| a.student_learning_objective_id}.include? objective.id
              p_report_lo= temp_ob.select{ |a| a.student_learning_objective_id == objective.id}.first
              @report_objective.lo_status = p_report_lo.lo_status.blank? ? Report::REPORT_STATUS[0][1] : p_report_lo.lo_status
            else
              @report_objective.lo_status = Report::REPORT_STATUS[0][1]
            end

          end

          if objective.is_completed == true
            @report_objective.lo_status = Report::REPORT_STATUS[2][1]
          end

          @report_objective.save

        end

        # end 121925395

        if @report_type == "EOY"
          
          uniq_schedules = @student.slot_schedules.where("academic_session_id = ? AND sub_subject_id NOT IN (select sub_subjects.id from sub_subjects INNER JOIN subjects ON subjects.id = sub_subjects.subject_id WHERE subjects.is_lunch = true OR subjects.is_tutorial = true OR subjects.is_ppa = true)", @selected_ay_id).pluck(:subject_id, :sub_subject_id, :user_id).uniq

          uniq_schedules.each do |schedule|
            @report_subject = ReportSubject.new
            @report_subject.report_id = @report.id
            @report_subject.subject_id = schedule[0]
            @report_subject.sub_subject_id = schedule[1]
            @report_subject.user_id = schedule[2]
            @report_subject.save
          end

          Subject.where("is_core = true").each do |sub|
            @report_core = ReportCoreSubject.new
            @report_core.report_id = @report.id
            @report_core.subject_id = sub.id
            @report_core.save
          end

        end

        format.html { redirect_to edit_report_path(@report, student_id: @student.id), notice: 'Report was successfully created.' }

      else

        format.html { redirect_to student_path(@student.id)+"#tab_reports", alert: 'A report for the current term already exists. Please edit the available report below.' }

      end

    end


    #   end
    #     format.html { redirect_to edit_report_path(@report,student_id: @student.id), notice: 'Report was successfully created.' }
    # end
    #   else
    # @report = Report.find_by(student_id: @student.id)
    #     respond_to do |format|
    #         format.html { redirect_to edit_report_path(@report,student_id: @student.id), notice: 'Report already exists.' }
    #     end
    #   end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  #custom
  def reports_add_evidence
    @master_csd_axis = MasterCsdAxis.all

    @report_objective=ReportObjective.find(params[:lo_id])
    @lo=@report_objective.student_learning_objective
    @student_lo_observation=@lo.observations.where(term_id: session[:global_current_term] ,academic_session_id: session[:global_academic_session] )

    @student=Student.find(params[:student_id])
    respond_to do |format|
      format.js {render 'reports/js/reports_add_evidence'}
    end
  end

  def save_report_evidence

    @report_lo = ReportObjective.find(params[:report_objective])
    @report_learning_objectives = Report.find(@report_lo.report_id).report_objectives
    @student = Report.find(@report_lo.report_id).student
    current_lo =[]
    available_lo =  @report_lo.report_objective_observations.pluck(:student_learning_objective_observation_id).map{ |x| x.to_s}

    if params[:check_ids]
      # current_lo = params[:check_ids]
      current_lo = params[:check_ids].uniq
      deleted_lo = available_lo - current_lo
    else
      deleted_lo = available_lo
    end
    new_lo = current_lo - available_lo
    # params[:check_ids].each do |key,value|

    if new_lo.present?
      new_lo.each_with_index do |(key,value),index|

        @student_observation = StudentLearningObjectiveObservation.find(key)
        # @observe = ReportObjectiveObservation.find_or_initialize_by(report_objective_id: params[:report_objective],student_learning_objective_observation_id: key)
        @observe = ReportObjectiveObservation.new

        @observe.position                                  = key #for observation position
        @observe.student_learning_objective_observation_id = key
        @observe.user_id                                   = @student_observation.user_id
        @observe.subject_id                                = @student_observation.subject_id.present? ? @student_observation.subject_id : (@student_observation.sub_subject_id.present? ? SubSubject.find(@student_observation.sub_subject_id).subject.id : "")
        @observe.sub_subject_id                            = @student_observation.sub_subject_id.present? ? @student_observation.sub_subject_id : ""
        @observe.summary_subject_name                      = @student_observation.summary_subject_name.present? ? @student_observation.summary_subject_name : ""

        @observe.report_objective_id                       = params[:report_objective]
        # @observe.summary                                   = @student_observation.date.to_s + " " + @student_observation.sub_subject.show_name + " " + @student_observation.description
        @observe.summary                                   = @student_observation.description

        @observe.create_date                               = @student_observation.date
        @observe.save

        StudentLearningObjectiveObservationFile.where(student_learning_objective_observation_id: key).pluck(:id).each_with_index do |file_id,index|
          @evidence = ReportObservationEvidence.new

          @evidence.position = index+1
          @evidence.report_objective_observation_id = @observe.id
          @evidence.student_learning_objective_observation_file_id = file_id
          @evidence.save
        end

      end
    end
    deleted_lo.collect { |id| ReportObjectiveObservation.where(student_learning_objective_observation_id: id).collect {|a| a.report_observation_evidences.destroy_all}}

    deleted_lo.collect { |id| ReportObjectiveObservation.where(student_learning_objective_observation_id: id).destroy_all}
    # @report_lo = ReportObjective.find(params[:report_objective])
    @master_csd_axis = MasterCsdAxis.all
    @p_level =MasterPLevel.pluck(:name)
    @p_sublevel = MasterPSubLevel.pluck(:name)
    respond_to do |format|
      format.js {render 'reports/js/save_report_evidence'}
    end
  end

  def save_sort_evidence

    if params[:report_id]

      @report_observation = ReportObservationEvidence.find(params[:file_id])

      # if ReportObjectiveEvidence.with_deleted.find_by(:student_learning_objective_observation_file_id=>@report_observation.student_learning_objective_observation_file_id).present?
      #   @report =  ReportObjectiveEvidence.with_deleted.find_by(:student_learning_objective_observation_file_id=>@report_observation.student_learning_objective_observation_file_id)
      #   @report.deleted_at = nil
      # else
      #   @report = ReportObjectiveEvidence.new
      # end

      # @report.report_objective_id = params[:report_id]
      # @report.position = params[:position_id]
      # @report.student_learning_objective_observation_file_id = @report_observation.student_learning_objective_observation_file_id
      # @report_observation.destroy
      # @report.save
      @report_observation.on_observation = false
      @report_observation.position = params[:position_id]
      @report_observation.save

    else

      # @evidence = ReportObservationEvidence.find_by(student_learning_objective_observation_file_id: params[:file_id])
      @evidence = ReportObservationEvidence.find_or_initialize_by(id: params[:file_id])
      @evidence.report_objective_observation_id = params[:observation_id]
      @evidence.position = params[:position_id]
      @evidence.on_observation = true
      @evidence.save

      # if !ReportObjectiveEvidence.find_by(student_learning_objective_observation_file_id: @evidence.student_learning_objective_observation_file_id).blank?
      #   @report_evidence  = ReportObjectiveEvidence.find_by(student_learning_objective_observation_file_id: @evidence.student_learning_objective_observation_file_id)
      #   @report_evidence.destroy
      # end
    end
    render :nothing => true
  end


  def save_observation_sort

    if params[:current_observation_position].to_i - params[:prev_observation_position].to_i < 0
      # ReportObjectiveObservation.where("position <=  ?",params[:prev_observation_position]).order("position DESC").each_with_index do |position,index|
      ReportObjectiveObservation.where("position <=  ?",params[:prev_observation_position]).each_with_index do |observe,index|
        observe.position = observe.position - 1
        observe.save
      end

      current = ReportObjectiveObservation.find(params[:current_observation])
      current.position =  params[:prev_observation_position].to_i
      current.save
    else

      ReportObjectiveObservation.where("position >=  ?",params[:next_observation_position]).each_with_index do |observe,index|
        observe.position = observe.position + 1
        observe.save

      end

      current = ReportObjectiveObservation.find(params[:current_observation])
      current.position =  params[:next_observation_position].to_i
      current.save
    end
    @report_lo = ReportObjective.find(params[:report_id])

    # respond_to do |format|
    # format.js {render 'reports/js/save_observation_sort'}
    render nothing: true
    # end
  end

  def save_curriculum_sort


    if params[:current_observation_position].to_i - params[:prev_observation_position].to_i < 0

      ReportSubjectObservation.where("position <=  ?",params[:prev_observation_position]).each_with_index do |observe,index|
        observe.position = observe.position - 1
        observe.save
      end

      current = ReportSubjectObservation.find(params[:current_observation])
      current.position =  params[:prev_observation_position].to_i
      current.save
    else

      ReportSubjectObservation.where("position >=  ?",params[:next_observation_position]).each_with_index do |observe,index|
        observe.position = observe.position + 1
        observe.save

      end

      current = ReportSubjectObservation.find(params[:current_observation])
      current.position =  params[:next_observation_position].to_i
      current.save
    end
    @report_lo = ReportObjective.find(params[:report_id])


    render nothing: true


  end




  def evidence_close

    evidence = ReportObservationEvidence.find(params[:file_id]).destroy
    render :nothing => true

  end
  def observation_close

    observation =  ReportObjectiveObservation.find(params[:observation_id])

    observation.report_observation_evidences.where(:on_observation => true).collect{ |id| (id).destroy}
    observation.destroy
    render :nothing => true


  end

  def curriculum_observation_close

    observation =  ReportSubjectObservation.find(params[:observation_id])

    observation.report_subject_observation_evidences.where(:on_observation => true).collect{ |id| (id).destroy}
    observation.destroy
    render :nothing => true

  end

  def save_report_summary

    @report = ReportObjective.find(params[:report_lo_id])
    @report.summary = params[:summary]
    @report.save
    @report_learning_objectives  = @report.report.report_objectives
    @student = @report.report.student
    @master_csd_axis = MasterCsdAxis.all
    respond_to do |format|
      format.js {render 'reports/js/save_report_lo_summary'}
    end
  end

  def save_observation_summary

    @report_observation         = ReportObjectiveObservation.find(params[:observation_id])
    @report_observation.summary = params[:summary]

    @report_learning_objectives = @report_observation.report.report_objectives

    @student = @report_observation.report.student
    @master_csd_axis = MasterCsdAxis.all

    @report_observation.save

    respond_to do |format|
      format.js {render 'reports/js/save_observation_summary'}
    end

  end

  def save_report_plevel
    @report_core = ReportCoreSubject.find_or_initialize_by(id: params[:report_core_subject_id])
    @report_core.p_level = params[:plevel]
    @report_core.save
    render :nothing => true

  end

  def save_report_sublevel
    @report_core = ReportCoreSubject.find_or_initialize_by(id: params[:report_core_subject_id])
    @report_core.p_sub_level = params[:p_sublevel]
    @report_core.save
    render :nothing => true

  end

  def report_subject_add_evidence
    @report_subject = ReportSubject.find(params[:report_subject_id])
    @student = Student.find(params[:student_id])

    respond_to do |format|
      format.js {render 'reports/js/report_subject_add_evidence'}
    end
  end

  def save_report_subject_evidence

    @report_subject = ReportSubject.find(params[:report_subject])
    @report = @report_subject.report

    current_ob = []
    available_ob =  @report_subject.report_subject_observations.pluck(:student_learning_objective_observation_id).map{ |x| x.to_s}

    if params[:check_ids]
      current_ob = params[:check_ids]
      deleted_ob = available_ob - current_ob
    else
      deleted_ob = available_ob
    end
    new_ob = current_ob - available_ob

    if new_ob.present?
      new_ob.each_with_index do |(key,value),index|

        @student_observation = StudentLearningObjectiveObservation.find(key)
        @report_subject_observation = ReportSubjectObservation.new

        @report_subject_observation.position                                  = key #for observation position
        @report_subject_observation.student_learning_objective_observation_id = key
        @report_subject_observation.user_id                                   = @student_observation.user_id
        @report_subject_observation.subject_id                                = @student_observation.subject_id
        @report_subject_observation.sub_subject_id                            = @student_observation.sub_subject_id
        @report_subject_observation.report_subject_id                         = params[:report_subject]
        @report_subject_observation.summary                                   = @student_observation.description
        @report_subject_observation.save

        StudentLearningObjectiveObservationFile.where(student_learning_objective_observation_id: key).pluck(:id).each_with_index do |file_id,index|
          @evidence = ReportSubjectObservationEvidence.new

          @evidence.position = index+1
          @evidence.report_subject_observation_id = @report_subject_observation.id
          @evidence.student_learning_objective_observation_file_id = file_id
          @evidence.save
        end
      end
    end

    deleted_ob.collect { |id| ReportSubjectObservation.where(student_learning_objective_observation_id: id).collect {|a| a.report_subject_observation_evidences.destroy_all}}
    deleted_ob.collect { |id| ReportSubjectObservation.where(student_learning_objective_observation_id: id).destroy_all}

    @report_subjects = @report.report_subjects
    @student = @report_subject.report.student
    @p_level =MasterPLevel.pluck(:name)
    @p_sublevel = MasterPSubLevel.pluck(:name)
    respond_to do |format|
      format.js {render 'reports/js/save_report_subject_evidence'}
    end
  end

  def save_report_sort_evidence
    if params[:report_id]

      @report_observation = ReportSubjectObservationEvidence.find(params[:file_id])

      @report_observation.on_observation = false
      @report_observation.position = params[:position_id]
      @report_observation.save

    else
      @evidence = ReportSubjectObservationEvidence.find_or_initialize_by(id: params[:file_id])
      @evidence.report_subject_observation_id = params[:observation_id]
      @evidence.position = params[:position_id]
      @evidence.on_observation = true
      @evidence.save
    end
    render :nothing => true
  end

  def save_reportsubject_plevel_one
    @report_subject = ReportSubject.find_or_initialize_by(id: params[:reportsubject_id])
    @report_subject.p_level_one = params[:p_level_one]
    @report_subject.save
    render :nothing => true

  end
  def save_reportsubject_plevel_two
    @report_subject = ReportSubject.find_or_initialize_by(id: params[:reportsubject_id])
    @report_subject.p_level_two = params[:p_level_one]
    @report_subject.save
    render :nothing => true

  end

  def save_reportsubject_psublevel_one

    @report_subject = ReportSubject.find_or_initialize_by(id: params[:reportsubject_id])
    @report_subject.p_sublevel_one = params[:p_sublevel_one]
    @report_subject.save
    render :nothing => true

  end

  def save_reportsubject_psublevel_two

    @report_subject = ReportSubject.find_or_initialize_by(id: params[:reportsubject_id])
    @report_subject.p_sublevel_two = params[:p_sublevel_one]
    @report_subject.save
    render :nothing => true

  end

  def save_reportsubject_summary
    @reportsubject = ReportSubject.find(params[:reportsubject_id])
    @reportsubject.summary = params[:summary]
    @reportsubject.save
    @report_subjects = @reportsubject.report.report_subjects
    @student = @reportsubject.report.student
    @p_level =MasterPLevel.pluck(:name)
    @p_sublevel = MasterPSubLevel.pluck(:name)
    respond_to do |format|
      format.js {render 'reports/js/save_reportsubject_summary'}
    end

  end

  def save_reportsubjectobservation_summary

    @report_observation         = ReportSubjectObservation.find(params[:observation_id])
    @report_observation.summary = params[:summary]

    @report_subjects = @report_observation.report.report_subjects

    @student = @report_observation.report.student


    @report_observation.save
    @p_level =MasterPLevel.pluck(:name)
    @p_sublevel = MasterPSubLevel.pluck(:name)
    respond_to do |format|
      format.js {render 'reports/js/save_reportsubjectobservation_summary'}
    end

  end

  def curriculum_evidence_close
    ReportSubjectObservationEvidence.find(params[:file_id]).destroy
    render  :nothing=>true
  end

  def report_download
    @print_type="pdf"
    @report = Report.find(params[:id])
    @student =  @report.student
    @report_learning_objectives = @report.report_objectives
    @report_core_subjects = @report.report_core_subjects
    @master_csd_axis = MasterCsdAxis.all
    @p_level =MasterPLevel.pluck(:name)
    @p_sublevel = MasterPSubLevel.pluck(:name)

    @report_subjects = @report.report_subjects

    @evidence_positions = @report.report_objectives.joins(:report_observation_evidences).pluck("report_observation_evidences.position")
    @report_subjects = @report.report_subjects
    respond_to do |format|

      pdf = render_to_string(pdf: 'MyPDF',template: 'reports/show.html.erb', page_size: 'A4', orientation: 'Portrait', outline: {outline: true} )
      @file_hash = SecureRandom.hex
      filepdf = 'report'<< @file_hash << '.pdf'

      pdf_directory = 'public/reports'
      Dir.mkdir(pdf_directory) unless File.exists?(pdf_directory)

      save_pdf_path = Rails.root.join(pdf_directory,filepdf)

      File.open(save_pdf_path, 'wb') do |file|
        file << pdf
      end



      format.js
    end
  end

  def report_send_reminder
    @rs = ReportSubject.find(params[:rs_id])
    respond_to do |format|
      format.js {render 'reports/js/report_send_reminder_modal'}
    end

  end
  def report_request_amend
    @rs = ReportSubject.find(params[:rs_id])
    respond_to do |format|
      format.js {render 'reports/js/request_amend_modal'}
    end

  end

  def save_request_amend
    @rs = ReportSubject.find(params[:rs_id])
    @report = @rs.report
    @student = @report.student
    @recipient = params[:to]
    @subject = params[:subject]
    @desc = params[:desc]
    Resque.enqueue(ReportAlert,@student.id,@rs.id,@recipient,@subject,@desc,action_name,current_user.id)

    respond_to do |format|
      format.html{redirect_to edit_report_path(id: @report.id,student_id: @student.id)+"#tab_create_reports_subjects",notice: "Amend Request sent"}
    end
  end

  def save_reminder
    @rs = ReportSubject.find(params[:rs_id])
    @report = @rs.report
    @student = @report.student
    @recipient = params[:to]
    @subject = params[:subject]
    @desc = params[:desc]
    Resque.enqueue(ReportAlert,@student.id,@rs.id,@recipient,@subject,@desc,action_name,current_user.id)
    respond_to do |format|
      format.html{redirect_to edit_report_path(id: @report.id,student_id: @student.id)+"#tab_create_reports_subjects",notice: "Reminder Sent"}
    end
  end

  def admin_send_reminder
    @report = Report.find(params[:rs_id])
    @student = @report.student
    @recipient = params[:to]
    @subject = params[:subject]
    @desc = params[:desc]
    Resque.enqueue(ReportAlert,@student.id,@report.id,@recipient,@subject,@desc,action_name,current_user.id)
    respond_to do |format|
      format.html{redirect_to edit_report_path(id: @report.id,student_id: @student.id)+"#tab_create_reports_subjects",notice: "Reminder Sent"}
    end
  end

  def send_for_approval

    @rep = Report.find(params[:report_id])

    @sending_ok = true
    # check blank subject summaries
    # if @rep.report_subjects.collect{|a| a.summary.blank? ? 'blank' : 'filled'}.uniq.include?("blank")
    #   @sending_ok = false
    # end

    # # check blank subject PLevel
    # if @rep.report_subjects.collect{|a| a.p_level_one.blank? ? 'blank' : 'filled'}.uniq.include?("blank")
    #   @sending_ok = false
    # end

    # # check blank subject PSubLevel
    # if @rep.report_subjects.collect{|a| a.p_sublevel_one.blank? ? 'blank' : 'filled'}.uniq.include?("blank")
    #   @sending_ok = false
    # end

    # blank subject summaries and plevels
    @rep.report_subjects.each do |rep_sub|
      if rep_sub.summary.blank? || rep_sub.p_level_one.blank? || rep_sub.p_sublevel_one.blank?
        @sending_ok = false
      end
      if rep_sub.sub_subject.level_count > 0
        if rep_sub.p_level_two.blank? || rep_sub.p_sublevel_two.blank?
          @sending_ok = false
        end
      end
    end

    # if Report.find(params[:report_id]).report_subjects.joins(:report_subject_observations).pluck("report_subject_observations.summary").blank?
    if @rep.report_objectives.collect{|a| a.summary.blank? ? 'blank' : 'filled'}.uniq.include?("blank")
      @sending_ok = false
    end

    if  @sending_ok == false

      flash[:alert] ="The report is currently incomplete, please finalize the report before submission."
      redirect_to :back

    else
      # @rep = Report.find(params[:report_id])
      @rep.status = "AA" # Set status to awaiting approval
      @rep.submitted_at = Date.today
      @rep.save

      @student= @rep.student
      @user = @student.get_phase.user


      # save acheivements
      # @report = Report.find(params[:report_id])

      @rep.report_objectives.each do |rlo|

        rlo.student_learning_objective.targets.each do |target|
          value = StudentLearningObjectiveAchievement.where("student_learning_objective_id = ? AND master_csd_axis_id=?",rlo.student_learning_objective.id, target.master_csd_axis_id).last
          # boundries = StudentLearningObjectiveTarget.find_by("student_learning_objective_id = ? AND master_csd_axis_id=?",rlo.student_learning_objective.id,last_achieve.master_csd_axis_id)

          @achievement = ReportObservationAchievement.find_or_initialize_by(report_objective_id: rlo.id,student_learning_objective_id:  rlo.student_learning_objective.id,master_csd_axis_id: target.master_csd_axis_id)

          if !value.blank?
            @achievement.achievement_value = value.achievement_value
          end
          @achievement.baseline_value = target.baseline_value
          @achievement.target_value = target.target_value
          @achievement.save
        end
      end

      Resque.enqueue(ReportAlert,@student.id,@rep.id,@user.id,@subject,@desc,action_name,current_user.id)

      # flash[:success]="The report has been submitted for approval to #{@user.name}."
      # redirect_to report_path(@report.id)

      redirect_to report_path(@rep.id), notice: "The report has been submitted for approval to #{@user.name}"

    end

  end


  def approve_report
    @rep = Report.find(params[:report_id])

    @approve_ok = true

    if @rep.report_core_subjects.collect{|a| a.p_level.blank? ? 'blank' : 'filled'}.uniq.include?("blank")
      @approve_ok = false
    end

    if @rep.report_core_subjects.collect{|a| a.p_sub_level.blank? ? 'blank' : 'filled'}.uniq.include?("blank")
      @approve_ok = false
    end


    if @approve_ok == true

      @rep.status = "AP"
      @rep.save

      @student= @rep.student
      @user = @rep.tutor

      Resque.enqueue(ReportAlert,@student.id,@rep.id,@user.id,@subject,@desc,action_name,current_user.id)

      # flash[:notice] = "The report has been approved and a confirmation has been sent to #{@user.name} "
      redirect_to report_path(@rep.id), notice: "The report has been approved and a confirmation has been sent to #{@user.name} "

    else

      flash[:alert] = "The core attainment levels have not been assigned. Please complete the report and try again. "
      redirect_to :back

    end


  end


  def admin_report_send_reminder

    @rep = Report.find(params[:report_id])

    respond_to do |format|
      format.js {render 'reports/js/admin_report_send_reminder_modal'}
    end

  end

  def admin_report_request_amend

    @rep = Report.find(params[:report_id])

    respond_to do |format|
      format.js {render 'reports/js/admin_request_amend_modal'}
    end

  end

  def send_back_unapproved

    @rep = Report.find(params[:rs_id])
    @rep.status = "IP"
    @rep.submitted_at = nil
    @rep.save

    @student= @rep.student
    # @user = @student.get_phase.user
    @desc = params[:desc]
    @user = @rep.tutor
    Resque.enqueue(ReportAlert,@student.id,@rep.id,@user.id,@subject,@desc,action_name,current_user.id)

    flash[:notice]="Amend request has been sent to #{@user.name}"
    redirect_to :back

  end

  # Unapprove functionality is added to make it possible for admins to unapprove report, edit and approve again
  def unapprove_report

    @rep = Report.find(params[:report_id])
    @rep.status = "AA"
    # @rep.submitted_at = nil
    @rep.save

    flash[:notice]="Report is now ready for editing. Please remember to approve the report again."
    redirect_to :back

  end

  def report_delete

    @report = Report.find(params[:report_id])
    # delete report subjects
    @report.report_subjects.each do|rs|
      rs.report_subject_observations.each do |rs_obs|
        rs_obs.report_subject_observation_evidences.each do |rs_evidence|
          rs_evidence.destroy
        end
        rs_obs.destroy
      end
      rs.destroy
    end
    #delete report objectives
    @report.report_objectives.each do|ro|

      ro.report_observation_achievements.each do |achieve|
        achieve.destroy
      end
      ro.report_objective_observations.each do |lo_obs|
        lo_obs.report_observation_evidences.each do |rlo_evidence|
          rlo_evidence.destroy
        end
        lo_obs.destroy
      end
      ro.destroy
    end

    @report.report_core_subjects.destroy_all

    @report.destroy

    flash[:notice] = "Report was successfully deleted."

    redirect_to :back
  end


  def report_play_video

    @file=StudentLearningObjectiveObservationFile.find(params[:file_id])


    respond_to do |format|
      format.js {render '/reports/js/report_play_video'}
    end
  end

  def change_lo_status

    @r_lo = ReportObjective.find(params[:report_lo_id])

    if params[:status].present?
      @r_lo.lo_status = params[:status]
      @r_lo.save

      @s_lo = @r_lo.student_learning_objective

      if @r_lo.lo_status == Report::REPORT_STATUS[2][1]
        if @r_lo.student_learning_objective.is_completed == false # Achieved

          @s_lo.is_completed = true
          @s_lo.achieved_date = Time.now
          @s_lo.temp_complete_user_id = current_user.id

          @s_lo.save

        end
      else

        @s_lo.is_completed = false
        @s_lo.achieved_date = nil
        @s_lo.temp_complete_user_id = nil

        @s_lo.save

      end

    end

    render nothing:true

  end
  # 121926299

  def set_report_objective_achievement

    @r_lo = ReportObjective.find(params[:report_objective_id])
    if @r_lo.report.status == 'IP'
      @student_achievement = StudentLearningObjectiveAchievement.new
      @student_achievement.student_learning_objective_id =  @r_lo.student_learning_objective.id
      @student_achievement.master_csd_axis_id = params[:master_axis_id].to_i
      @student_achievement.achievement_value = params[:axis_value].to_i
      @minaxisvalue = params[:minaxisvalue]
      @maxaxisvalue = params[:maxaxisvalue]
      @student_achievement.save
      @common_achievement = @student_achievement

    else
      @report_achievement                              = ReportObservationAchievement.find_by(report_objective_id: @r_lo,master_csd_axis_id: params[:master_axis_id].to_i,student_learning_objective_id: @r_lo.student_learning_objective_id )
      # @report_achievement.report_objective_id          = @r_lo.id
      # @report_achievement.student_learning_objective_id = @r_lo.student_learning_objective_id
      # @report_achievement.master_csd_axis_id           = params[:master_axis_id].to_i
      @report_achievement.achievement_value            = params[:axis_value].to_i
      # @report_achievement.baseline_value               = params[:minaxisvalue].to_i
      # @report_achievement.target_value                 = params[:maxaxisvalue].to_i
      @report_achievement.save

      @minaxisvalue = params[:minaxisvalue]
      @maxaxisvalue = params[:maxaxisvalue]
      @common_achievement = @report_achievement

    end

    respond_to do |format|
      format.js {render '/reports/js/set_report_objective_achievement'}

    end
  end
  # end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_report
    # @report = Report.find(params[:id])
  end

  def calculate_ranges
    # set min and max years from academic sessions
    @year_range = []
    AcademicSession.all.each do |session|
      name = session.name.split("-").map{|x| x.to_i}
      @year_range << name.first << name.last
    end
    @year_range = @year_range.uniq

    # set range based on params or default to range bounds
    @min_range = params[:range_min] || @year_range.first
    @max_range = params[:range_max] || @year_range.last

    if @min_range.to_i >= @max_range.to_i
      @max_range = @min_range
    end

    # set search range bounds
    @find_range = []
    AcademicSession.all.each do |session|
      name = session.name.split("-").map{|x| x.to_i}
      if name.first.to_i >= @min_range.to_i && name.first.to_i <= @max_range.to_i
        @find_range << session.id
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def report_params
    params[:report]
  end

  def infer_report_variable_values(selected_term_id, selected_ay_id)

    term_name = Term.find(selected_term_id).master_term.display_name
    term_start_year = Term.find(selected_term_id).start_date.year

    final_term = (Term.find(selected_term_id).academic_session.terms.order(:id).last.id == selected_term_id ? true : false )

    year_name = AcademicSession.find(selected_ay_id).name

    if final_term
      @report_title = "#{year_name.split("-").last} End of Year Report"
      @report_type = "EOY"
    else
      @report_title = "#{term_name} #{term_start_year} End of Term Report"
      @report_type = "EOT"
    end

  end


  # def calculate_bounds(val)
  #   result = []
  #   quotient = val / 3
  #   remainder = val % 3
  #   if remainder > 0
  #     quotient = quotient + 1
  #   end
  #   result << quotient
  #   result << remainder

  #   return result
  # end
end
