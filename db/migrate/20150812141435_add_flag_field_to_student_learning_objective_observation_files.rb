class AddFlagFieldToStudentLearningObjectiveObservationFiles < ActiveRecord::Migration
  def change
  	 add_column :student_learning_objective_observation_files, :file_flag,:boolean, :default => false
  end
end
