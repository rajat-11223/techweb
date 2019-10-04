class TutorGroupsController < ApplicationController
  before_action :set_tutor_group, only: [:show, :edit, :update, :destroy]

  # GET /tutor_groups
  # GET /tutor_groups.json
  def index
    @tutor_groups = TutorGroup.where(academic_session_id: session[:global_academic_session])
    if !@tutor_groups.blank?
      authorize @tutor_groups
    end
    
  end

  # GET /tutor_groups/1
  # GET /tutor_groups/1.json
  # def show
  # end

  # GET /tutor_groups/new
  # NOT USED
  # def new
  #   @phases=Phase.where(academic_session_id:  session[:global_academic_session])

  #   @tutor_group = TutorGroup.new
  #   @tutor_group.tutor_group_students.build

  #   @available_user_array = User.all.pluck(:id) - TutorGroup.where(academic_session_id: session[:global_academic_session]).joins(:user).pluck(:id)
  #   @users = @available_user_array.collect{|u| User.find(u)}
    
  #   # @users = User.all
  #   @students = Student.all
  # end

  # GET /tutor_groups/1/edit
  # NOT USED
  # def edit
  # end

  # POST /tutor_groups
  # POST /tutor_groups.json

  # for saving a new group
  def create

    @tutor_group = TutorGroup.new(tutor_group_params)
    @tutor_group.academic_session_id=session[:global_academic_session]

    respond_to do |format|
      if @tutor_group.save

        if params[:students]
          params[:students].each do |stud|
            @student=Student.find_by(:id=>stud)
            @student.temp_tg_user_id=0
            @student.save

            @student_tg=@student.tutor_group_students.find_or_initialize_by(:academic_session_id=>session[:global_academic_session],:student_id=>@student.id)
            @student_tg.tutor_group_id=@tutor_group.id
            @student_tg.save
          end
        end

        format.html { redirect_to tutor_groups_path, notice: @tutor_group.name + ' was successfully created.' }
        format.json { render :show, status: :created, location: @tutor_group }
      else
        format.html { render :new }
        format.json { render json: @tutor_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tutor_groups/1
  # PATCH/PUT /tutor_groups/1.json

  # for updating an existing group

  def update

    respond_to do |format|
      if @tutor_group.update(tutor_group_params)
        if params[:students]
             params[:students].each do |stud|
            @student=Student.find_by(:id=>stud)
            @student.temp_tg_user_id=0
            @student.save
          end
          updated_students = params[:students]

          existing_students = @tutor_group.students.collect{|s| "#{s.id}"}


          new_students = updated_students - existing_students
          deleted_students = existing_students - updated_students


          new_students.each do |s|
            @students_tg = TutorGroupStudent.find_or_initialize_by(:academic_session_id=>session[:global_academic_session], student_id: s) 
            @students_tg.tutor_group_id = @tutor_group.id
            @students_tg.save
          end

          deleted_students.collect { |id| TutorGroupStudent.where(tutor_group_id: @tutor_group.id, student_id: id).destroy_all}
      else
        TutorGroupStudent.where(tutor_group_id: @tutor_group.id).destroy_all
      end

      format.html { redirect_to tutor_groups_path, notice: @tutor_group.name + ' was successfully updated.' }
      format.json { render :show, status: :ok, location: @tutor_group }
      else
        format.html { render :edit }
        format.json { render json: @tutor_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tutor_groups/1
  # DELETE /tutor_groups/1.json

  # for deleting a group

  def destroy
    if @tutor_group.tutor_group_students.present?
      @tutor_group.tutor_group_students.destroy_all
    end
    @tutor_group.destroy
    respond_to do |format|
      format.html { redirect_to tutor_groups_url, notice: @tutor_group.name + ' was successfully deleted.' }
      format.json { head :no_content }
    end
  end


  # custom methods

  # open modal for new tg creation

  def new_tg_modal
@tutor_group = TutorGroup.new

    available_user_array = User.all.pluck(:id) - TutorGroup.where(academic_session_id: session[:global_academic_session]).joins(:user).pluck(:user_id)
    @users = available_user_array.collect{|u| User.find(u)}
    @students = Student.all
    @phases=Phase.where(academic_session_id:  session[:global_academic_session])
    respond_to do |format|
      format.js {render '/tutor_groups/js/new_tg_modal'}
    end

  end

  # open modal for existing tg updation

  def edit_tutor_group
    
    # @students = Student.all
    @tutor_group=TutorGroup.find_by(:id=>params[:group_id])
    
    available_user_array = User.all.pluck(:id) - TutorGroup.where(academic_session_id: session[:global_academic_session]).joins(:user).pluck(:user_id)
    if !@tutor_group.user.deleted?
      available_user_array = (available_user_array.reverse << @tutor_group.user.id).reverse
    end
    @users = available_user_array.collect{|u| User.with_deleted.find(u)}

    @phases=Phase.where(academic_session_id:  session[:global_academic_session])
    students=@tutor_group.students
    students.each do |stud|
      stud.temp_tg_user_id= current_user.id
      stud.save
    end
    @students=Student.where(:temp_tg_user_id=>current_user.id)

    respond_to do |format|
      format.js {render '/tutor_groups/js/edit_tutor_group'}
    end
  end

  # adding a student while new group creation

  def add_student
    @phases=Phase.where(academic_session_id:  session[:global_academic_session])

    @stud=Student.find_by(:id=>params[:id])

    # @student_phase = @stud.show_phase_id
    @student_phase = @stud.phase_id(session[:global_academic_session])


    if @stud.temp_tg_user_id != 0
      @custom=1
      respond_to do |format|
        format.js {render '/tutor_groups/js/add_student'}
      end
    else
      @stud.temp_tg_user_id = current_user.id
      @stud.save
      @students=Student.where(:temp_tg_user_id=>current_user.id)
      @from_js = true
      respond_to do |format|
        format.js {render '/tutor_groups/js/add_student'}
      end
    end
  end

  # removing a student while new group creation

  def remove_student
    @phases=Phase.where(academic_session_id:  session[:global_academic_session])

    @stud=Student.find_by(:id=>params[:id])
    # @student_phase = @stud.show_phase_id
    @student_phase = @stud.phase_id(session[:global_academic_session])

    @stud.temp_tg_user_id=0
    @stud.save
    @students=Student.where(:temp_tg_user_id=>current_user.id)

    @from_js = true
    respond_to do |format|
      format.js {render '/tutor_groups/js/remove_student'}
    end
  end

  # reset student lg_user_id flag while hiding/closing a modal

  def reset_student
    @students=[]
    @studentss=Student.where(temp_tg_user_id: current_user.id)
    @studentss.each do |stud|
      stud.temp_tg_user_id=0
      stud.save
      @students << stud
    end
    
    available_user_array = User.all.pluck(:id) - TutorGroup.where(academic_session_id: session[:global_academic_session]).joins(:user).pluck(:user_id)
    @users = available_user_array.collect{|u| User.find(u)}

    @phases=Phase.where(academic_session_id:  session[:global_academic_session])

    @tutor_group = TutorGroup.new
    respond_to do |format|
      format.js {render '/tutor_groups/js/reset_student'}
    end
  end

  # add a student while updation

  def update_tutor_group_student

    @phases=Phase.where(academic_session_id:  session[:global_academic_session])

    @tutor_group=TutorGroup.find_by(:id=>params[:tutor])

    available_user_array = User.all.pluck(:id) - TutorGroup.where(academic_session_id: session[:global_academic_session]).joins(:user).pluck(:user_id)
    available_user_array = (available_user_array.reverse << @tutor_group.user.id).reverse
    @users = available_user_array.collect{|u| User.find(u)}
    
    @stud=Student.find_by(:id=>params[:student])
    @stud.temp_tg_user_id= current_user.id
    @stud.save
    # @student_phase = @stud.show_phase_id
    @student_phase = @stud.phase_id(session[:global_academic_session])


    @students=Student.where(:temp_tg_user_id=>current_user.id)

    respond_to do |format|
      format.js {render '/tutor_groups/js/update_tutor_group_student'}
    end
  end

  # removing a student while updation

  def remove_student_from_tutor_group_while_edit
    @phases=Phase.where(academic_session_id:  session[:global_academic_session])

    @tutor_group=TutorGroup.find_by(:id=>params[:tutor])

    available_user_array = User.all.pluck(:id) - TutorGroup.where(academic_session_id: session[:global_academic_session]).joins(:user).pluck(:user_id)
    available_user_array = (available_user_array.reverse << @tutor_group.user.id).reverse
    @users = available_user_array.collect{|u| User.find(u)}

    @stud=Student.find(params[:student])
    @stud.temp_tg_user_id= 0
    @stud.save
    
    # @student_phase = @stud.show_phase_id
    @student_phase = @stud.phase_id(session[:global_academic_session])

    @students=Student.where(:temp_tg_user_id=>current_user.id)
    # @students_val=Student.where(:temp_tutor_group=>'0')
    respond_to do |format|
      format.js {render '/tutor_groups/js/remove_student_from_tutor_group_while_edit'}
    end
  end

  # for checking uniqueness of tutor group name

  def unique_tutor_name
   
    respond_to do |format|
      if TutorGroup.find_by(name: params[:name], academic_session_id: session[:global_academic_session]).present?
        @tutor_group_exists = true
        format.js {render '/tutor_groups/js/unique_tutor_name'}
      else
        @tutor_group_exists = false
        format.js {render '/tutor_groups/js/not_unique_tutor_name'}
      end  
    end
  end 

   def update_unique_tutor_name

    respond_to do |format|
      if TutorGroup.find_by(name: params[:name], academic_session_id: session[:global_academic_session]).present?

        tg = TutorGroup.find_by(name: params[:name], academic_session_id: session[:global_academic_session])
        if tg.id == params[:tg_id].to_i
       @tutor_group_exists = false
        format.js {render '/tutor_groups/js/not_unique_tutor_name'}
      else
        @tutor_group_exists = true
        format.js {render '/tutor_groups/js/unique_tutor_name'}
      end
      else
        @tutor_group_exists = false
        format.js {render '/tutor_groups/js/not_unique_tutor_name'}
      end  
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tutor_group
    @tutor_group = TutorGroup.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tutor_group_params
    params.require(:tutor_group).permit(:name, :user_id, tutor_group_students_attributes: [:student_id])
  end
  
end