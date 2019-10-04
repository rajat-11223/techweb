class AddLoStatusToReport < ActiveRecord::Migration
  def change
  		add_column :report_objectives,:lo_status,:string
  end
end
