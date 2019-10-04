class AddParanoiaTo < ActiveRecord::Migration
  def change
  	add_column :report_objective_observations,	:deleted_at,	:datetime
  	add_column :report_subject_observations,	:deleted_at,	:datetime

  end
end
