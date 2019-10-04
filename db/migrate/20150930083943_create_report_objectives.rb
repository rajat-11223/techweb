class CreateReportObjectives < ActiveRecord::Migration
  def change
    create_table :report_objectives do |t|

    		t.references		:report
    		t.references		:student_learning_objective
    		t.references 		:subject
    		t.references 		:sub_subject
    		t.string				:p_level
    		t.date					:assigned_date
    		t.date					:target_date
    		t.text					:summary
    		t.integer				:position

      t.timestamps null: false
    end
  end
end
