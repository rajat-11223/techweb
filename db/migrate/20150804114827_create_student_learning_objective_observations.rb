class CreateStudentLearningObjectiveObservations < ActiveRecord::Migration
  def change
    create_table :student_learning_objective_observations do |t|

    	t.references 	:student_learning_objective
    	t.references	:user
    	t.references	:subject
    	t.references	:sub_subject
    	t.datetime		:deleted_at
    	
    	
      t.timestamps null: false
    end
  end
end
