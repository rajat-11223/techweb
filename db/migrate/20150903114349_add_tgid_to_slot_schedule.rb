class AddTgidToSlotSchedule < ActiveRecord::Migration
  def change
  	  	add_column :slot_schedules,:tutor_group_id,:integer,:default=> 0

  end
end
