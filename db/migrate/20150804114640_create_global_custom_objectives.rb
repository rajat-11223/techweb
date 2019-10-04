class CreateGlobalCustomObjectives < ActiveRecord::Migration
  def change
    create_table :global_custom_objectives do |t|

    	t.string		:subject_name
    	t.references 	:subject
    	t.string		:sub_subject_name
    	t.references 	:sub_subject
    	t.text			:description
    	t.string		:p_level
    	t.integer		:p_level_position
    	t.datetime		:deleted_at
    	

      t.timestamps null: false
    end
  end
end
