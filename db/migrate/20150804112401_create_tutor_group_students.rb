class CreateTutorGroupStudents < ActiveRecord::Migration
  def change
    create_table :tutor_group_students do |t|

    	t.references		:tutor_group
    	t.references		:student
    	t.datetime 			:deleted_at

      t.timestamps null: false
    end
  end
end
