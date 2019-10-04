class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|

    	t.string		:name,						null: false
    	t.string		:display_name
    	t.boolean   	:is_pfc,					:default=> false
      	t.boolean   	:is_ppa,          			:default=> false
      	t.boolean   	:is_core,         			:default=> false
    	t.integer   	:position
    	t.datetime 		:deleted_at
      

      t.timestamps null: false
    end
  end
end
