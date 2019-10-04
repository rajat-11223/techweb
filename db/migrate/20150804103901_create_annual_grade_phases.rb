class CreateAnnualGradePhases < ActiveRecord::Migration
  def change
    create_table :annual_grade_phases do |t|

    	t.references 	:annual_grade
    	t.references 	:phase
    	t.datetime 		:deleted_at

      t.timestamps null: false
    end
  end
end
