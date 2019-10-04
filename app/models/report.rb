class Report < ActiveRecord::Base
  #extend FriendlyId
  #friendly_id :id, use: :slugged
  belongs_to :student, -> {with_deleted}
  belongs_to :user, -> {with_deleted}
  belongs_to :tutor, -> {with_deleted}, class_name: "User", foreign_key: "tutor_id"
  has_many :report_core_subjects
  has_many :report_objectives
  has_many :report_subjects
  belongs_to :term

  REPORT_STATUS = [["Ongoing","OG"],["To Be Reviewed","TBR"],["Achieved","AC"]]

def should_generate_new_friendly_id?
  title_changed?
end
  def check_tutor_user_changed
    tutor_group = self.student.tutor_groups.where(academic_session_id: self.academic_session_id).last
    if tutor_group
      if tutor_group.try(:user_id) == self.tutor_id
        return [false, nil]
      else
        return [true, tutor_group.try(:name)]
      end
    else
      return [false, nil]
    end
  end

end
