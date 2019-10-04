class StaffProfilesController < ApplicationController
  before_action :set_staff_profile, only: [:show, :edit, :update, :destroy]

  # GET /staff_profiles
  # GET /staff_profiles.json
  def index
  # @staff_profiles = StaffProfile.all
if params[:view]=="Deactive"
      @user_deactive =true
      @users=User.only_deleted 
    else
    @users = User.all
  end
  @user = User.new
  authorize @users
  end

  # GET /staff_profiles/1
  # GET /staff_profiles/1.json
  def show

    @master_csd_axis = MasterCsdAxis.all

    # @user=User.find_by(params[:id])

    # @student_learning_objectives = @user.student_learning_objectives.joins(:student).order("students.fname ASC")
    @student_learning_objectives = @user.student_learning_objectives.joins(:student).where(is_closed:false, is_completed: false).order("students.fname ASC")

    @selected_academic_session = session[:global_academic_session]
    @selected_tutor = params[:id]

    @academic_sessions = AcademicSession.all.order("id DESC")

    @master_days = MasterDay.all
    @slots = Slot.where(academic_session_id: @selected_academic_session, is_taught_time: true)

    # @term = Term.where("academic_session_id = ? AND start_date < ? AND end_date > ?", @selected_academic_session, Time.now, Time.now).last
    
    current_term = Term.where("academic_session_id = ? AND start_date <= ? AND end_date >= ?", @selected_academic_session, Time.now, Time.now).order(:master_term_id).last
    
    if !current_term.blank?
      @term = Term.where("academic_session_id = ? AND start_date <= ? AND end_date >= ?", @selected_academic_session, Time.now, Time.now).order(:master_term_id).last
    else
      if !Term.where("academic_session_id = ? AND start_date <= ?", @selected_academic_session, Time.now).order(:master_term_id).blank? # middle of two terms in an available session
        @term = Term.where("academic_session_id = ? AND start_date <= ?", @selected_academic_session, Time.now).order(:master_term_id).last
      else # middle of academic years after annual closure
        @term = Term.where("academic_session_id = ?", @selected_academic_session).order(:master_term_id).first
      end
    end


    @slot_schedules = SlotSchedule.where(term_id: @term.id, user_id: @selected_tutor)  

    @has_schedule = @slot_schedules.blank? ? false : true

  end

  # GET /staff_profiles/new
  def new
  # @staff_profile = StaffProfile.new
  @user = User.new
  end

  # GET /staff_profiles/1/edit
  def edit
  end

  # POST /staff_profiles
  # POST /staff_profiles.json
  def create


    @user = User.invite!(user_params) do |u|
      if !params[:a]

        u.skip_invitation = true
      end
      u.avatar = params[:user][:avatar]
    end

  # Build user type table associations for tutor and teacher
  UserType.find_or_create_by(user_id: @user.id, master_user_type_id: MasterUserType.find_by(name: "teacher").id)
  UserType.find_or_create_by(user_id: @user.id, master_user_type_id: MasterUserType.find_by(name: "tutor").id)

  if params[:is_team_lead] == "1"
    UserType.find_or_create_by(user_id: @user.id, master_user_type_id: MasterUserType.find_by(name: "team-lead").id)
  end

  # @staff_profile = StaffProfile.new(staff_profile_params)

  respond_to do |format|
    if @user.save
      format.html { redirect_to :back, notice: @user.name + ' was successfully created.' }
    else
      format.html { render :new }
    end
  end


  end
  # custom methods


  def open_new_staff_modal_from_index
    @user = User.new


    @from_js = true
    respond_to do |format|
      format.js {render '/staff_profiles/js/open_new_staff_modal_from_index'}
    end
  end


  def edit_staff_profile

    @user=User.find_by(:id=>params[:staff_id])

    respond_to do |format|
      format.js {render '/staff_profiles/js/edit_staff_profile'}
    end
  end
  # end
 
  # PATCH/PUT /staff_profiles/1
  # PATCH/PUT /staff_profiles/1.json
  def update

    if params[:is_team_lead]  
      UserType.find_or_create_by(user_id: @user.id, master_user_type_id: MasterUserType.find_by(name: "team-lead").id)
    else
      if @user.master_user_types.find_by(:name=>"team-lead").present?
        @user.user_types.find_by(:master_user_type_id=>  MasterUserType.find_by(name: "team-lead").id).destroy
      end
    end

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to :back, notice: @user.name + "'s details were successfully updated." }
        format.json { render :show, status: :ok, location: @staff_profile }
      else
        format.html { render :edit }
        format.json { render json: @staff_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staff_profiles/1
  # DELETE /staff_profiles/1.json
  def destroy

    @user.destroy
    respond_to do |format|
      format.html { redirect_to staff_index_path, notice: @user.name + ' was successfully deactivated.' }
      format.json { head :no_content }
    end
  end


  # custom methods
  def send_invite
    @user=User.find_by(:id=>params[:id])
  # @user.invitation_sent_at=Time.now

  respond_to do |format|
    if @user.deliver_invitation
      @user.save
      format.html { redirect_to staff_index_path, notice: @user.name + ' was successfully invited.' }
    end 
  end
  end

  def unique_user_email
    
    if User.with_deleted.find_by(:email => params[:email]).present?
     respond_to do |format|
     format.js {render '/staff_profiles/js/email_exists'}
   end
    else
    respond_to do |format|
     format.js {render '/staff_profiles/js/email_not_exists'}
    end

     

  end
  end

  def update_unique_user_email

    if User.with_deleted.find_by(:email => params[:email]).present? 
      if User.with_deleted.find(params[:user_id]).email==params[:email]
          respond_to do |format|
             format.js {render '/staff_profiles/js/update_email_not_exists'}
            end
      else
        respond_to do |format|
          format.js {render '/staff_profiles/js/update_email_exists'}
        end
      end
    else
      respond_to do |format|
        format.js {render '/staff_profiles/js/update_email_not_exists'}
      end
    end
  end


  def reactivate_user
      @reactivate_user=User.with_deleted.find(params[:user_id])
          @reactivate_user.deleted_at=nil
          @reactivate_user.save
         
          respond_to do |format|

          format.html {redirect_to staff_index_path(view: "Deactive"), notice: @reactivate_user.name + " was successfully reactivated" }

         end
    
  end
  def change_user_pwd

    @user=User.find(params[:user_id])
     respond_to do |format|
        format.js {render '/staff_profiles/js/change_user_pwd'}
      end
    
  end

  def save_new_pwd
      
    @user=User.find(params[:user_id])
      respond_to do |format|
      if     @user.update_with_password(update_pwd_params)
            sign_in @user, :bypass => true
            format.html { redirect_to staff_path(@user.id), notice: 'Password was successfully updated.' }
        else
        
          #   if Devise::Encryptor.compare(User, @user.encrypted_password, params[:user][:current_password])
          #     format.html { redirect_to staff_path(@user.id), notice: 'Password and confirmation dont match' }
    
          #   else
              format.html { redirect_to staff_path(@user.id), alert: 'Current password is incorrect' }

            # end
        end
    end
  end
  # end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_staff_profile
    @user = User.with_deleted.find(params[:id])

  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # def staff_profile_params
  #   params[:user]
  # end

  def user_params
    params.require(:user).permit(:email, :fname, :lname, :isd_code, :mobile_phone, :home_phone, :description, :avatar)
  end
def update_pwd_params
        params.require(:user).permit(:password, :password_confirmation,:current_password)
    end
end
