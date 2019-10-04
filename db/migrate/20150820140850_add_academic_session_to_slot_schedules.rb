class AddAcademicSessionToSlotSchedules < ActiveRecord::Migration
  def change
  	  	add_column :slot_schedules, :academic_session_id, :integer

  end
end
