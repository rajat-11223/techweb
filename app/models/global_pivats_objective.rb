class GlobalPivatsObjective < ActiveRecord::Base

		belongs_to :global_lo_import_file
		belongs_to :subject
		belongs_to :sub_subject
		has_many :global_pivats_sublevels
end
