class CreateGlobalPivatsObjectives < ActiveRecord::Migration
  def change
    create_table :global_pivats_objectives do |t|

    	t.references 	:global_lo_import_file
    	t.string		:subject_name
    	t.references 	:subject
    	t.string		:sub_subject_name
    	t.references 	:sub_subject
    	t.text			:description
    	t.string		:p_level
    	t.integer		:p_level_position
    	t.text			:e
    	t.text			:d
    	t.text			:c
    	t.text			:b
    	t.text			:a
    	t.datetime		:deleted_at
    	


      t.timestamps null: false
    end
  end
end
