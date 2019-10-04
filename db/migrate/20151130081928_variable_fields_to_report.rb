class VariableFieldsToReport < ActiveRecord::Migration
  def change
  	  		 add_column :report_objectives, :is_completed, :integer
  	  		 add_column :report_observation_achievements, :baseline_value, :integer
  	  		 add_column :report_observation_achievements, :target_value, :integer

  end
end
