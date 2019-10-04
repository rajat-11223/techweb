class AddDeletedToLg < ActiveRecord::Migration
  def change
	add_column :learning_groups,:deleted_at,:datetime

  end
end
