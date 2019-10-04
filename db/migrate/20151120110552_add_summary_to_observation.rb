class AddSummaryToObservation < ActiveRecord::Migration
  def change
	add_column :student_learning_objective_observations,	:is_summary,			:boolean, 	default: false
	add_column :student_learning_objective_observations,	:summary_subject_name,	:string
	add_column :student_learning_objective_observations,	:term_id,				:integer
	add_column :student_learning_objective_observations,	:academic_session_id, 	:integer
  end
end
