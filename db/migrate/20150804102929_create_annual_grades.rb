class CreateAnnualGrades < ActiveRecord::Migration
  def change
    create_table :annual_grades do |t|

    	t.references :academic_session
    	t.references :master_grade

      t.timestamps null: false
    end
  end
end
