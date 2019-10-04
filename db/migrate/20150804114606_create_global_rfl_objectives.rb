class CreateGlobalRflObjectives < ActiveRecord::Migration
  def change
    create_table :global_rfl_objectives do |t|

    	t.references 	:global_lo_import_file
    	t.integer		:position
    	t.text			:description
    	t.datetime		:deleted_at
    	

      t.timestamps null: false
    end
  end
end
