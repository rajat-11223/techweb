class AnnualGradePhase < ActiveRecord::Base

	acts_as_paranoid

	belongs_to :annual_grade
	belongs_to :phase

end
