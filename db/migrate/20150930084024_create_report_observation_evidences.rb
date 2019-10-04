class CreateReportObservationEvidences < ActiveRecord::Migration
  def change
    create_table :report_observation_evidences do |t|

			t.references	:report_objective_observation
    	t.references	:student_learning_objective_observation_file
    	t.text				:summary
    	t.integer			:position
      t.timestamps null: false
    end
  end
end
