class AddSublevelToReportLo < ActiveRecord::Migration
  def change
  	  	add_column :report_objectives,:p_sublevel,:text

  end
end
