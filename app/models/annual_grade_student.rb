class AnnualGradeStudent < ActiveRecord::Base

	belongs_to :annual_grade
	belongs_to :student
	
end
