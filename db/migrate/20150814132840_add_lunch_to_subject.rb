class AddLunchToSubject < ActiveRecord::Migration
  def change

  	add_column :subjects, :is_lunch, :boolean, default: false

  end
end
