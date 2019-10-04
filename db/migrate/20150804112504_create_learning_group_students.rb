class CreateLearningGroupStudents < ActiveRecord::Migration
  def change
    create_table :learning_group_students do |t|

    	t.references		:learning_group
    	t.references		:student
    	t.datetime 			:deleted_at

      t.timestamps null: false
    end
  end
end
