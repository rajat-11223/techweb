class LearningGroupStudent < ActiveRecord::Base

	acts_as_paranoid
	
	belongs_to :learning_group
	belongs_to :student
end
