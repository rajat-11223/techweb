class CreateReportObjectiveEvidences < ActiveRecord::Migration
  def change
    create_table :report_objective_evidences do |t|

    	t.references	:report_objective
    	t.references	:student_learning_objective_observation_file
    	t.integer			:position

      t.timestamps null: false
    end
  end
end
