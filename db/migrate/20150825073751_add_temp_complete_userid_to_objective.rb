class AddTempCompleteUseridToObjective < ActiveRecord::Migration
  def change
  	add_column :student_learning_objectives,:temp_complete_user_id,:integer
  end
end
