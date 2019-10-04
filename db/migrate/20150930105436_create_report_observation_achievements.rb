class CreateReportObservationAchievements < ActiveRecord::Migration
  def change
    create_table :report_observation_achievements do |t|

    	t.references 	:report_objective
    	t.references 	:student_learning_objective
    	t.references	:master_csd_axis
    	t.integer			:achievement_value

      t.timestamps null: false
    end
  end
end
