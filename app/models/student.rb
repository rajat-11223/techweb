class Student < ActiveRecord::Base
  acts_as_paranoid
  # has_one :tutor_group_student
  # has_one :tutor_group, through: :tutor_group_student

  # has_one :learning_group_student
  # has_one :learning_group, through: :learning_group_student

  # has_one :user ,through: :tutor_group

  has_many :phases

  has_many :alerts, as: :object_entity

  has_many :tutor_group_students
	has_many :tutor_groups, through: :tutor_group_students

  has_many :learning_group_students
  has_many :learning_groups, through: :learning_group_students

  has_many :users ,through: :tutor_groups

  has_many :annual_grade_students
  has_many :annual_grades, through: :annual_grade_students
  has_many :phases, through: :annual_grades
  
  has_many :student_learning_objectives
  has_many :individual_observations, class_name:  "StudentLearningObjectiveObservation"
  has_many :observations, through: :student_learning_objectives 

  has_many :slot_schedule_students
  has_many :slot_schedules, through: :slot_schedule_students

  has_many :reports
  has_many :student_profiles

  belongs_to   :temp_tutor, class_name: "User", foreign_key: "temp_tg_user_id"
  belongs_to   :temp_leader, class_name: "User", foreign_key: "temp_lg_user_id"
 
  # accepts_nested_attributes_for :annual_grade_student, :allow_destroy => true


	has_attached_file   				:avatar, 
                     					:styles => {:thumb => "128x128#", :square=>"200x200#",:medium => "300x200#",:large=>"450x300#"}

	validates_attachment_size           :avatar, :less_than => 10.megabytes 
  	validates_attachment_content_type 	:avatar,
  										:content_type => [/\Aimage\/(jpg|jpeg|pjpeg|png|x-png)\z/],
                                       	:message => 'file type is not allowed (only jpeg/png images)'

  has_many :student_important_infos
  accepts_nested_attributes_for  :student_important_infos,:allow_destroy=>true, :reject_if => proc { |att| att[:description].blank? }

  def name
      self.fname + " " + self.lname
  end

  # def tutor_group_name
  #   if self.tutor_group.present?
  #     self.tutor_group.name
  #   else
  #     "-" 
  #   end
  # end

  # def tutor_name
  #   if self.user.present?
  #     self.user.name
  #   else
  #     "" 
  #   end
  # end

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


  def show_tutor_group_id(academic_session)
    if !self.tutor_groups.blank? 
      has_a_tutor_group_currently = self.tutor_groups.find_by(:academic_session_id =>  academic_session)
    else
      has_a_tutor_group_currently = false
    end

    if has_a_tutor_group_currently
      return has_a_tutor_group_currently.id
    else
      return 0
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

  def show_learning_group_color(academic_session)
    if !self.learning_groups.blank? 
      has_a_learning_group_currently = self.learning_groups.find_by(:academic_session_id =>  academic_session)
    else
      has_a_learning_group_currently = false
    end

    if has_a_learning_group_currently
      return has_a_learning_group_currently.color
    else
      return ""
    end
  end 

  def show_learning_group_id(academic_session)
    if !self.learning_groups.blank? 
      has_a_learning_group_currently = self.learning_groups.find_by(:academic_session_id =>  academic_session)
    else
      has_a_learning_group_currently = false
    end

    if has_a_learning_group_currently
      return has_a_learning_group_currently.id
    else
      return 0
    end
  end

  def show_tutor_group_tutor_name(academic_session)

    if !self.tutor_groups.blank? 
      has_a_tutor_group_currently = self.tutor_groups.find_by(:academic_session_id =>  academic_session)
    else
      has_a_tutor_group_currently = false
    end

    if has_a_tutor_group_currently
      return has_a_tutor_group_currently.user.name
    else
      return ""
    end

  end

  def show_phase  # do not use further, to be removed later
    !self.annual_grade_students.last.annual_grade.annual_grade_phase.blank? ?  self.annual_grade_students.last.annual_grade.annual_grade_phase.phase.name : ""
  end

  def get_phase # do not use further, to be removed later
    !self.annual_grade_students.last.annual_grade.annual_grade_phase.blank? ?  self.annual_grade_students.last.annual_grade.annual_grade_phase.phase : ""
  end

  def show_phase_id # do not use further, to be removed later
    !self.annual_grade_students.last.annual_grade.annual_grade_phase.blank? ?  self.annual_grade_students.last.annual_grade.annual_grade_phase.phase.id : 0
  end

  def phase(academic_session)
    # self.annual_grade_students.last.annual_grade.annual_grade_phase.blank? ?  self.annual_grade_students.last.annual_grade.annual_grade_phase.phase.name : ""
    !self.annual_grade_students.joins(:annual_grade).where("annual_grades.academic_session_id = ?", academic_session).blank? ? self.annual_grade_students.joins(:annual_grade).where("annual_grades.academic_session_id = ?", academic_session).first.annual_grade.phase : ""
  end

  def phase_id(academic_session)
    !self.phase(academic_session).blank? ? self.phase(academic_session).id : 0
  end

  def check_basevalue(lo_id,axis_id,academic_session_id,term_id)

    self.reports.find_by(academic_session_id: academic_session_id,term_id: term_id - 1)
  @r_objective = ReportObjective.where(:student_learning_objective_id=> lo_id)
  @student_objective = StudentLearningObjective.find(lo_id)
  if @r_objective.present?
    if @r_objective.last.student_learning_objective.achievements.present? 
      if @r_objective.last.student_learning_objective.achievements.where(master_csd_axis_id: axis_id).present? 
        return @r_objective.last.student_learning_objective.achievements.where(master_csd_axis_id: axis_id).last.achievement_value
      else
        !@student_objective.targets.find_by(master_csd_axis_id: axis_id).blank? ? @student_objective.targets.find_by(master_csd_axis_id: axis_id).baseline_value : 0
      end
    else
    !@student_objective.targets.find_by(master_csd_axis_id: axis_id).blank? ? @student_objective.targets.find_by(master_csd_axis_id: axis_id).baseline_value : 0

    end
   else
        # return x_id == StudentLearningObjective.find(lo_id).target_lower_bound(axis_id)
    !@student_objective.targets.find_by(master_csd_axis_id: axis_id).blank? ? @student_objective.targets.find_by(master_csd_axis_id: axis_id).baseline_value : 0

   end 
    end



  def show_avatar(size)
     if self.avatar? 
        path = self.avatar.url(size)
    else
        path ="/assets/custom/no-image.png"
    end
    return path
  end




end
