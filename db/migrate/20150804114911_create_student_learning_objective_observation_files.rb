class CreateStudentLearningObjectiveObservationFiles < ActiveRecord::Migration
  def change
    create_table :student_learning_objective_observation_files do |t|

    	t.references 	:student_learning_objective_observation
    	t.attachment	:evidence
    	t.datetime		:deleted_at
    	
      t.timestamps null: false
    end
  end
end
