class ChangeColorFiledLg < ActiveRecord::Migration
  def change
  	change_column :learning_groups, :color,:string,:default=> '#000000'
  end
end
