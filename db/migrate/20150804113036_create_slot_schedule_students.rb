class CreateSlotScheduleStudents < ActiveRecord::Migration
  def change
    create_table :slot_schedule_students do |t|

    	t.references 	:slot_schedule
    	t.references	:student
    	t.integer 		:associated_group_id
    	t.string 		:associated_group_type


      t.timestamps null: false
    end
  end
end
