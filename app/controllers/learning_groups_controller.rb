class LearningGroupsController < ApplicationController
  before_action :set_learning_group, only: [:show, :edit, :update, :destroy]

  # GET /learning_groups
  # GET /learning_groups.json
  def index
    @phases=Phase.where(academic_session_id:  session[:global_academic_session])

    @learning_groups = LearningGroup.where(academic_session_id: session[:global_academic_session])
    @learning_group = LearningGroup.new
    @teamlead = MasterUserType.find_by(:name => "team-lead").users

    if !@learning_groups.blank? 
      authorize @learning_groups
    end

  end

  # GET /learning_groups/1
  # GET /learning_groups/1.json
  def show
  end

  # GET /learning_groups/new
  def new
    @learning_group = LearningGroup.new
  end

  # GET /learning_groups/1/edit
  def edit
  end

  # POST /learning_groups
  # POST /learning_groups.json
  def create

    @learning_group = LearningGroup.new(learning_group_params)
    @learning_group.academic_session_id = session[:global_academic_session]


    respond_to do |format|
      if @learning_group.save

        if params[:students]

          params[:students].each do |stud|

            @student=Student.find_by(:id=>stud)

            @student.temp_lg_user_id=0
            @student.save

            @student_lg=@student.learning_group_students.find_or_initialize_by(:academic_session_id=>session[:global_academic_session],:student_id=>@student.id)
            @student_lg.learning_group_id=@learning_group.id
            @student_lg.save

          end
        end

        format.html { redirect_to learning_groups_path, notice: @learning_group.name + ' was successfully created.' }
        format.json { render :show, status: :created, location: @learning_group }

      else

      # format.html { render :new }
      format.json { render json: @learning_group.errors, status: :unprocessable_entity }

      end

    end

  end

  # PATCH/PUT /learning_groups/1
  # PATCH/PUT /learning_groups/1.json
  def update
    respond_to do |format|
      if @learning_group.update(learning_group_params)
        if params[:students]

           params[:students].each do |stud|
            @student=Student.find_by(:id=>stud)
            @student.temp_lg_user_id=0
            @student.save
          end
            updated_students = params[:students]
            existing_students = @learning_group.students.collect{|s| "#{s.id}"}
            new_students = updated_students - existing_students
            deleted_students = existing_students - updated_students
            
            new_students.each do |s|
              @students_lg = LearningGroupStudent.find_or_initialize_by(:academic_session_id=>session[:global_academic_session], student_id: s) 
              @students_lg.learning_group_id = @learning_group.id
              @students_lg.save
            end

          #     new_students.collect { |id| LearningGroupStudent.where( student_id: id).destroy_all }

          # new_students.collect { |id| LearningGroupStudent.create(learning_group_id: @learning_group.id, student_id: id) }
          deleted_students.collect { |id| LearningGroupStudent.where(learning_group_id: @learning_group.id, student_id: id).destroy_all}
        else
          LearningGroupStudent.where(learning_group_id: @learning_group.id).destroy_all
        end

        format.html { redirect_to learning_groups_path, notice: @learning_group.name + ' was successfully updated.' }
        format.json { render :show, status: :ok, location: @learning_group }
      else
         format.html { render :edit }
         format.json { render json: @learning_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /learning_groups/1
  # DELETE /learning_groups/1.json
  def destroy
    if @learning_group.students.present?

      @learning_group.students.destroy_all
    end
    @learning_group.destroy
    respond_to do |format|
      format.html { redirect_to learning_groups_url, notice: @learning_group.name + ' was successfully deleted.' }
      format.json { head :no_content }
    end
  end


  # custom methods

  def open_learning_group_form_from_modal
    respond_to do |format|
      format.js {render '/learning_groups/js/open_learning_group_form_from_modal'}
    end
  end

  def add_student_to_learning_group
    @phases=Phase.where(academic_session_id:  session[:global_academic_session])

    @stud=Student.find_by(:id=>params[:id])
    # @student_phase = @stud.show_phase_id
    @student_phase = @stud.phase_id(session[:global_academic_session])
  #  @stud.temp_lesson_group=1
  #  @stud.save
  #  @students=Student.where(:temp_lesson_group=>true)
  # @from_js = true
  #  respond_to do |format|
  #    format.js {render '/learning_groups/js/add_student_to_learning_group'}
  #  end
  if @stud.temp_lg_user_id != 0
    @custom=1
    respond_to do |format|
      format.js {render '/learning_groups/js/add_student_to_learning_group'}    
    end
  else
    @stud.temp_lg_user_id = current_user.id
    @stud.save
    @students=Student.where(:temp_lg_user_id=>current_user.id)

    respond_to do |format|
      format.js {render '/learning_groups/js/add_student_to_learning_group'}    
    end
  end
  end




  def remove_added_student_to_learning_group
    @phases=Phase.where(academic_session_id:  session[:global_academic_session])

    @stud=Student.find_by(:id=>params[:id])
    # @student_phase = @stud.show_phase_id
    @student_phase = @stud.phase_id(session[:global_academic_session])

    @stud.temp_lg_user_id=0
    @stud.save
    @students=Student.where(:temp_lg_user_id=>current_user.id)

    @from_js = true
    respond_to do |format|
      format.js {render '/learning_groups/js/remove_added_student_to_learning_group'}
    end
  end

  def edit_learning_group_from_index

    @phases=Phase.where(academic_session_id:  session[:global_academic_session])

    @teamlead=MasterUserType.find_by(:name => "team-lead").users
    @learning_group=LearningGroup.find_by(:id=>params[:group_id])
    @learning_group.students.each do |stud|
      stud.temp_lg_user_id= current_user.id
      stud.save
    end
    @students=Student.where(:temp_lg_user_id=>current_user.id)
    respond_to do |format|
      format.js {render '/learning_groups/js/edit_learning_group_from_index'}
    end
  end

  def update_added_student_while_editing
    @phases=Phase.where(academic_session_id:  session[:global_academic_session])

    @teamlead=MasterUserType.find_by(:name => "team-lead").users

    @learning_group=LearningGroup.find_by(:id=>params[:learning_group])
    @stud=Student.find_by(:id=>params[:student])
    # @student_phase = @stud.show_phase_id 
    @student_phase = @stud.phase_id(session[:global_academic_session])

    @stud.temp_lg_user_id= current_user.id
    @stud.save

    @students=Student.where(:temp_lg_user_id=>current_user.id)
    respond_to do |format|
      format.js {render '/learning_groups/js/update_added_student_while_editing'}
    end
  end

  def remove_student_from_learning_group_while_editing
    @phases=Phase.where(academic_session_id:  session[:global_academic_session])

    @teamlead=MasterUserType.find_by(:name => "team-lead").users

    @learning_group=LearningGroup.find_by(:id=>params[:learning_group])

    @stud=Student.find_by(:id=>params[:student])
    # @student_phase = @stud.show_phase_id 
    @student_phase = @stud.phase_id(session[:global_academic_session])
     
    @stud.temp_lg_user_id=0
    @stud.save

    @students=Student.where(temp_lg_user_id: current_user.id)

    respond_to do |format|
      format.js {render '/learning_groups/js/remove_student_from_learning_group_while_editing'}
    end
  end

  def reset_learning_student

    @phases=Phase.where(academic_session_id:  session[:global_academic_session])

    @students=[]
    @studentss=Student.where(temp_lg_user_id: current_user.id)
    @studentss.each do |stud|
      stud.temp_lg_user_id=0
      stud.save
      @students<<stud
    end
    @teamlead=MasterUserType.find_by(:name => "team-lead").users

    @learning_group = LearningGroup.new
    respond_to do |format|
      format.js {render '/learning_groups/js/reset_learning_student'}
    end 
  end

def unique_learning_name


    respond_to do |format|
      if LearningGroup.find_by(name: params[:name], academic_session_id: session[:global_academic_session]).present? 
        @learning_group_exists = true
        format.js {render '/learning_groups/js/unique_learning_name'}
      else
        @learning_group_exists = false
        format.js {render '/learning_groups/js/not_unique_learning_name'}
      end  
    end
 
end
def update_unique_learning_name

respond_to do |format|
      if LearningGroup.find_by(name: params[:name], academic_session_id: session[:global_academic_session]).present? 
         lg = LearningGroup.find_by(name: params[:name], academic_session_id: session[:global_academic_session])

         if lg.id==params[:lg_id].to_i
         @learning_group_exists = false
        format.js {render '/learning_groups/js/not_unique_learning_name'}

         else
        @learning_group_exists = true
        format.js {render '/learning_groups/js/unique_learning_name'}
      end
      else
        @learning_group_exists = false
        format.js {render '/learning_groups/js/not_unique_learning_name'}
      end  
    end
 
end

  # end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_learning_group
    @learning_group = LearningGroup.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def learning_group_params
    params.require(:learning_group).permit(:academic_session_id,:user_id,:name,:color,learning_group_student_attributes:
      [:student_id])
  end
end
