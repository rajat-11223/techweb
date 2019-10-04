class AddTextToGlobalRflObjectives < ActiveRecord::Migration
  def change
	add_column :global_rfl_objectives,:additional_text,:text
  end
end
