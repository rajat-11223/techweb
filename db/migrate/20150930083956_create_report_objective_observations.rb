class CreateReportObjectiveObservations < ActiveRecord::Migration
  def change
    create_table :report_objective_observations do |t|

    	t.references	:report_objective
    	t.references	:student_learning_objective
    	t.references	:student_learning_objective_observation
    	t.references	:user
    	t.references	:subject
    	t.references	:sub_subject
    	t.datetime		:create_date
    	t.text				:summary
    	t.integer			:position
      t.timestamps null: false
    end
  end
end
