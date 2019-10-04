class AnnualGrade < ActiveRecord::Base

	belongs_to :master_grade
	belongs_to :academic_session

	has_many :annual_grade_students
	has_one :annual_grade_phase
	has_one :phase, through: :annual_grade_phase

end
