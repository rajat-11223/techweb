class AddTutorialToSubjects < ActiveRecord::Migration
  def change
  	add_column :subjects,:is_tutorial,:boolean, default: false

  end
end
