class AddTimelineStateToUser < ActiveRecord::Migration
  def change

	add_column :users, :timeline_minimized, :boolean, default: false

  end
end
