class AddLgIdToSlotSchedule < ActiveRecord::Migration
  def change
  	  	add_column :slot_schedules,:learning_group_id,:integer,:default=> 0

  end
end
