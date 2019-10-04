class CreateStudentLearningObjectiveTargets < ActiveRecord::Migration
  def change
    create_table :student_learning_objective_targets do |t|

    	t.references 	:student_learning_objective
    	t.references	:master_csd_axis
    	t.integer		:baseline_value
    	t.integer		:target_value
    	t.datetime		:deleted_at
    	
      t.timestamps null: false
    end
  end
end
