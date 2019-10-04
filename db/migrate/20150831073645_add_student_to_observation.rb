class AddStudentToObservation < ActiveRecord::Migration
  def change
add_column :student_learning_objective_observations,:student_id,:integer

  end
end
