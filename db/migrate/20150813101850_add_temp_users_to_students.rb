class AddTempUsersToStudents < ActiveRecord::Migration
  def change
  	 add_column :students, :temp_lg_user_id, :integer, default: 0
  	 add_column :students, :temp_tg_user_id, :integer, default: 0
  end
end
