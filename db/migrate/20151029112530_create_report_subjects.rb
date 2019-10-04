class CreateReportSubjects < ActiveRecord::Migration
  def change
    create_table :report_subjects do |t|

    		t.references		:report
    		t.references		:student_learning_objective
    		t.references        :user
    		t.references 		:subject
    		t.references 		:sub_subject
    		t.string			:p_level_one
    		t.string			:p_level_two
    		t.string			:p_sublevel_one
    		t.string			:p_sublevel_two
    		t.boolean			:is_completd,:default=>false
    		t.text					:summary
    		t.integer				:position
      t.timestamps null: false
    end
  end
end
