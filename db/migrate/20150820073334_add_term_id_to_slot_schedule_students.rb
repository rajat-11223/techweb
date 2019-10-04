class AddTermIdToSlotScheduleStudents < ActiveRecord::Migration
  def change

  	add_column :slot_schedule_students, :slot_id, :integer
  	add_column :slot_schedule_students, :term_id, :integer
  	add_column :slot_schedule_students, :master_day_id, :integer
  	
  end
end
