class AddLevelsToSubsubject < ActiveRecord::Migration
  def change
	add_column :sub_subjects,:level_count,:integer, default: 0
	add_column :sub_subjects,:l1_sub_name,:string
	add_column :sub_subjects,:l2_sub_name,:string
  end
end
