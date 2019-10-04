class CreateSummaryLearningObjectives < ActiveRecord::Migration
  def change
    create_table :summary_learning_objectives do |t|

    	t.integer :summary_obs_id
    	t.integer :original_obs_id

      t.timestamps null: false
    end
  end
end
