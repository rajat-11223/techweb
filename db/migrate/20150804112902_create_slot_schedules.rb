class CreateSlotSchedules < ActiveRecord::Migration
  def change
    create_table :slot_schedules do |t|

    	t.references :slot
    	t.references :term
    	t.references :master_day
    	t.references :subject
    	t.references :sub_subject
    	t.references :user

      t.timestamps null: false
    end
  end
end
