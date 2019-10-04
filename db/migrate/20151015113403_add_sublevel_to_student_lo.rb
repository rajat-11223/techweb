class AddSublevelToStudentLo < ActiveRecord::Migration
  def change
	add_column :student_learning_objectives,:p_sublevel,:string
  end
end
