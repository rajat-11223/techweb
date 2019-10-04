class AddSessionToFocusSubjects < ActiveRecord::Migration
  def change
  	  	add_column :student_learning_objective_focus_subjects, :academic_session_id, :integer
  	  	add_column :student_learning_objective_focus_subjects, :term_id, :integer
  	  	add_column :student_learning_objective_focus_subjects, :user_id, :integer
  end
end
