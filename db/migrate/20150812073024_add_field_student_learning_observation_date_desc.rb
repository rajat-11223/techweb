class AddFieldStudentLearningObservationDateDesc < ActiveRecord::Migration
  def change
  	  	add_column :student_learning_objective_observations, :description,:text
  	  	add_column :student_learning_objective_observations, :date,:date

  end
end
