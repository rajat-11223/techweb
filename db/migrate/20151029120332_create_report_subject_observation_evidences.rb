class CreateReportSubjectObservationEvidences < ActiveRecord::Migration
  def change
    create_table :report_subject_observation_evidences do |t|

			t.references	:report_subject_observation
    	t.references	:student_learning_objective_observation_file
    	t.boolean			:on_observation,:default=>true
    	t.integer			:position
      t.timestamps null: false
    end
  end
end
