class CreateStudentLearningObjectiveAchievements < ActiveRecord::Migration
  def change
    create_table :student_learning_objective_achievements do |t|

    	t.references 	:student_learning_objective_observation
    	t.references 	:student_learning_objective
    	t.references	:master_csd_axis
    	t.integer		:achievement_value
    	t.datetime		:deleted_at
    	
      t.timestamps null: false
    end
  end
end
