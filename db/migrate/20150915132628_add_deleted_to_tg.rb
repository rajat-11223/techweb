class AddDeletedToTg < ActiveRecord::Migration
  def change
	add_column :tutor_groups,:deleted_at,:datetime
  end
end
