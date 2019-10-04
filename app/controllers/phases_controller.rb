class PhasesController < ApplicationController
  before_action :set_phase, only: [:show, :edit, :update, :destroy]

  # GET /phases
  # GET /phases.json
  def index
    @phases = Phase.where(:academic_session_id => session[:global_academic_session])
    #puts "your session id is".to_s + session[:global_academic_session].to_s
    authorize @phases

  end 

  # GET /phases/1
  # GET /phases/1.json
  def show
  end

  # GET /phases/new
  def new
    @phase = Phase.new

    @master_grades = MasterGrade.all
    @team_leaders = MasterUserType.find_by(:name => "team-lead").users
    @unassigned_years = Phase.where(:academic_session_id => session[:global_academic_session]).joins(:annual_grades).pluck(:master_grade_id)

    respond_to do |format|
      format.js {render '/phases/js/add_phase'}
    end

  end

  # GET /phases/1/edit
  def edit

    @master_grades = MasterGrade.all
    @team_leaders = MasterUserType.find_by(:name => "team-lead").users
    @current_lead = @phase.user

    @phase_grades = @phase.annual_grades.joins(:master_grade).pluck(:master_grade_id)
    @unassigned_years = Phase.where(:academic_session_id => session[:global_academic_session]).joins(:annual_grades).pluck(:master_grade_id)

    respond_to do |format|
      format.js {render '/phases/js/edit_phase'}
    end

  end

  # POST /phases
  # POST /phases.json
  def create

    @phase = Phase.new(phase_params)
    @phase.academic_session_id = session[:global_academic_session]

    respond_to do |format|
      if @phase.save

        @years = params[:phase_years]
        @years.each do |key,value|
          if value != "0"
            annual_grade = AnnualGrade.find_by(academic_session_id: @phase.academic_session_id, master_grade_id: key)
            annual_grade_phase = AnnualGradePhase.find_or_initialize_by(annual_grade_id: annual_grade.id)
            annual_grade_phase.phase_id = @phase.id
            annual_grade_phase.save 
          end
        end

        format.html { redirect_to phases_path, notice: @phase.name + ' was successfully created.' }
        format.json { render :show, status: :created, location: @phase }
      else
        format.html { render :new }
        format.json { render json: @phase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /phases/1
  # PATCH/PUT /phases/1.json
  def update

    respond_to do |format|
      if @phase.update(phase_params)

        years = params[:phase_years]
        new_years = []

        years.each do |key,value|
          if value != "0"
  # annual_grade = AnnualGrade.find_by(academic_session_id: @phase.academic_session_id, master_grade_id: key)
  # new_years << annual_grade.id
  new_years << key.to_i
  end
  end

  old_years = @phase.annual_grades.joins(:master_grade).pluck(:master_grade_id)

  added_years = new_years - old_years
  removed_years =  old_years - new_years

  added_years.each do |y|
    annual_grade = AnnualGrade.find_by(academic_session_id: @phase.academic_session_id, master_grade_id: y)
    annual_grade_phase = AnnualGradePhase.find_or_initialize_by(annual_grade_id: annual_grade.id)
    annual_grade_phase.phase_id = @phase.id
    annual_grade_phase.save 
  end

  removed_years.each do |r|
    annual_grade = AnnualGrade.find_by(academic_session_id: @phase.academic_session_id, master_grade_id: r)
    AnnualGradePhase.where(phase_id: @phase.id, annual_grade_id: annual_grade.id).destroy_all

  end


  format.html { redirect_to phases_path, notice: @phase.name + ' was successfully updated.' }
  format.json { render :show, status: :ok, location: @phase }
  else
    format.html { render :edit }
    format.json { render json: @phase.errors, status: :unprocessable_entity }
  end
  end
  end

  # DELETE /phases/1
  # DELETE /phases/1.json
  def destroy

    @phase.destroy
    @phase.annual_grades.destroy_all
    respond_to do |format|
      format.html { redirect_to phases_url, notice: @phase.name + ' was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_phase
    @phase = Phase.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def phase_params
    params.require(:phase).permit(:name, :user_id)
  end

end
