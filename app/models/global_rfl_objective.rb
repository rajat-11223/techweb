class GlobalRflObjective < ActiveRecord::Base


		belongs_to :global_lo_import_file
		has_many :student_learning_objectives, as: :global_lo


end
