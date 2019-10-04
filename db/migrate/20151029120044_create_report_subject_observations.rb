class CreateReportSubjectObservations < ActiveRecord::Migration
  def change
    create_table :report_subject_observations do |t|

    	t.references	:report_subject
    	t.references	:student_learning_objective
    	t.references	:student_learning_objective_observation
    	t.references	:user
    	t.references	:subject
    	t.references	:sub_subject
    	t.text			:summary
    	t.integer		:position
      t.timestamps null: false
    end
  end
end
