class CreateSubSubjects < ActiveRecord::Migration
  def change
    create_table :sub_subjects do |t|

    	t.references 	:subject
		t.string		:name,						null: false
    	t.string		:display_name
      	t.boolean   	:is_core,          			:default=> false
      	t.boolean   	:is_pfc,           			:default=> false
      	t.boolean   	:is_tutorial,      			:default=> false
      	t.boolean   	:is_none,          			:default=> false
    	t.integer    	:position
    	t.datetime 		:deleted_at

      t.timestamps null: false
    end
  end
end
