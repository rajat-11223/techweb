class AddPivatsSubjectFlag < ActiveRecord::Migration
  def change
  	add_column :subjects,:is_pivats,:boolean, default: false

  end
end
