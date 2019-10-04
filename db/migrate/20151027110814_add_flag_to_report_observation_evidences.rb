class AddFlagToReportObservationEvidences < ActiveRecord::Migration
  def change
  	  		add_column :report_observation_evidences,:on_observation,:boolean,:default=> true

  end
end
