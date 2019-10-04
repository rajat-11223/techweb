class AddPfcToStudentGrade < ActiveRecord::Migration
  def change

  	    add_column :annual_grade_students, :is_pfc, :boolean, default: false
  end
end
