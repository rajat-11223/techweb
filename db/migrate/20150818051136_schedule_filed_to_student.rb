class ScheduleFiledToStudent < ActiveRecord::Migration
  def change
  	 add_column :students, :temp_schedule_user_id, :integer, default: 0
  end
end
