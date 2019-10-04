class CreateAnnualGradeStudents < ActiveRecord::Migration
  def change
    create_table :annual_grade_students do |t|

    	t.references 	:annual_grade
    	t.references 	:student
    	t.datetime 		:deleted_at

      t.timestamps null: false
    end
  end
end
