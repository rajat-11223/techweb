class AddUserLearningObjective < ActiveRecord::Migration
  def change
  		 add_column :student_learning_objectives, :user_id, :integer
  end
end
