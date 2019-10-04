class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|

    	t.references 	:academic_session
    	t.string		:name
    	t.datetime		:start_time
    	t.datetime		:end_time
    	t.boolean		:is_taught_time,			default: false

      t.timestamps null: false
    end
  end
end
