class AddAcademicSessionToTgLg < ActiveRecord::Migration
  def change

  	add_column :tutor_group_students,:academic_session_id,:integer
  	add_column :learning_group_students,:academic_session_id,:integer
  end
end
