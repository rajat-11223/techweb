class AddOriginalObservationTo < ActiveRecord::Migration
  def change 
  	
  		 add_column :student_learning_objective_observation_files, :original_obs_id, :integer

  end
end
