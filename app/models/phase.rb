class Phase < ActiveRecord::Base

	belongs_to :academic_session
	belongs_to :user, -> {with_deleted}

	has_many :annual_grade_phases
	has_many :annual_grades, through: :annual_grade_phases
	has_many :annual_grade_students, through: :annual_grades
	has_many :students, through: :annual_grade_students

	def team_lead_name
		!self.user.deleted? ? self.user.name : ""
	end

	# def years
	# 	self.phase_school_years.joins(:master_school_year)
	# end		

end
