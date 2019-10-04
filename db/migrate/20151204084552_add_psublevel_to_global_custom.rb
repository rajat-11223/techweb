class AddPsublevelToGlobalCustom < ActiveRecord::Migration
  def change
  	  	add_column :global_custom_objectives,:p_sublevel,:text

  end
end
