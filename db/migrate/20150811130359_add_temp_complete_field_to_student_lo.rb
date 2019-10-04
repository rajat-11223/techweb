class AddTempCompleteFieldToStudentLo < ActiveRecord::Migration
  def change
  	add_column :student_learning_objectives, :temp_complete,:boolean, :default=>false
  end
end
