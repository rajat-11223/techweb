class AddAchievedDateToStudentLo < ActiveRecord::Migration
  def change
	add_column :student_learning_objectives,:achieved_date,:date
  end
end
