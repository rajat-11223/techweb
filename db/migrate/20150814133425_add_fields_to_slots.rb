class AddFieldsToSlots < ActiveRecord::Migration
  def change
  	
  	add_column :slots, :is_scheduled_time, :boolean, default: false

  end
end
