class AddTutorIdToReport < ActiveRecord::Migration
  def change
	add_column :reports, :tutor_id,:integer

  end
end
