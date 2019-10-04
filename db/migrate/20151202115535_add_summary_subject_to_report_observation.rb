class AddSummarySubjectToReportObservation < ActiveRecord::Migration
  def change
  	add_column :report_objective_observations,	:summary_subject_name,	:string
  end
end
