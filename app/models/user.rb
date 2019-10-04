class User < ActiveRecord::Base
  acts_as_paranoid
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :rememberable, :registerable, and :omniauthable
  devise :invitable, :database_authenticatable, 
         :recoverable, :trackable, :validatable, :timeoutable
  def after_password_reset; end

  validates_uniqueness_of :email
  has_many :slot_schedules
  has_many :user_types
  has_many :master_user_types,  :through => :user_types

  has_many :student_learning_objectives

  has_many :learning_groups
  has_many :learning_group_students, through: :learning_groups
  has_many :lg_students, through: :learning_group_students, source: :student

  has_many :tutor_groups
  has_many :tutor_group_students, through: :tutor_groups
  has_many :tg_students, through: :tutor_group_students, source: :student

  has_many :focus_classes, class_name:  "StudentLearningObjectiveFocusSubject"

  has_many :phases

  has_many :reports, foreign_key: :tutor_id 

  has_attached_file   :avatar, 
                      :styles => {:micro => "100x100#",:thumb => "200x200#",:medium => "500x500#"}
 
  validates_attachment_size           :avatar, :less_than => 10.megabytes 
  validates_attachment_content_type   :avatar, 
                                      :content_type => [/\Aimage\/(jpg|jpeg|pjpeg|png|x-png)\z/],
                                      :message => 'file type is not allowed (only jpeg/png images)'


# Role determination for Pundit
  def role?(role_sym)
    
    self.master_user_types.pluck(:name).include?(role_sym) ? true : false
  end

  def name
      self.fname + " " + self.lname
  end

  def is_team_lead?
      if self.user_types.pluck(:master_user_type_id).include? MasterUserType.find_by(name: "team-lead").id
        return true
      else
        return false
      end
  end   

  def is_admin?

      if self.user_types.pluck(:master_user_type_id).include? MasterUserType.find_by(name: "admin").id
        return true
      else
        return false
      end
  end    

  def is_student_tutor?(academic_session, student_id)

      if self.tutor_group_students.where(academic_session_id: academic_session).pluck(:student_id).include?(student_id)
        return true
      else
        return false
      end
  end  

  def lead_phase_name(academic_session)

    if !self.phases.blank? 
      leads_a_phase_currently = self.phases.find_by(:academic_session_id =>  academic_session)
    else
      leads_a_phase_currently = false
    end

    if leads_a_phase_currently
      return leads_a_phase_currently.name
    else
      return ""
    end

  end  

  def lead_phase_id(academic_session)

    if !self.phases.blank? 
      leads_a_phase_currently = self.phases.find_by(:academic_session_id =>  academic_session)
    else
      leads_a_phase_currently = false
    end

    if leads_a_phase_currently
      return leads_a_phase_currently.id
    else
      return 0
    end

  end

  def get_phase(academic_session)

    if !self.phases.blank? 
      leads_a_phase_currently = self.phases.find_by(:academic_session_id =>  academic_session)
    else
      leads_a_phase_currently = false
    end

    if leads_a_phase_currently
      return leads_a_phase_currently
    else
      return nil
    end

  end

  def show_tutor_group_name(academic_session)

    if !self.tutor_groups.blank? 
      has_a_tutor_group_currently = self.tutor_groups.find_by(:academic_session_id =>  academic_session)
    else
      has_a_tutor_group_currently = false
    end

    if has_a_tutor_group_currently
      return has_a_tutor_group_currently.name
    else
      return ""
    end

  end  

  def get_tutor_group(academic_session)

    if !self.tutor_groups.blank? 
      has_a_tutor_group_currently = self.tutor_groups.find_by(:academic_session_id =>  academic_session)
    else
      has_a_tutor_group_currently = false
    end

    if has_a_tutor_group_currently
      return has_a_tutor_group_currently
    else
      return nil
    end

  end

  

  def show_learning_group_name(academic_session)

    if !self.learning_groups.blank? 
      has_a_learning_group_currently = self.learning_groups.find_by(:academic_session_id =>  academic_session)
    else
      has_a_learning_group_currently = false
    end

    if has_a_learning_group_currently
      return has_a_learning_group_currently.name
    else
      return ""
    end

  end

  def show_avatar(size)

    if self.avatar? 
        path = self.avatar.url(size)
    else
        path = "custom/no-image.png"
    end
    return path

  end

  # def send_reset_password_instructions
  #   Devise::Mailer.reset_password_instructions(resource, {}).deliver
  # end

  # def reset_password_instructions
  #  super
  # end
  
end
