class CreateReportCoreSubjects < ActiveRecord::Migration
  def change
    create_table :report_core_subjects do |t|

      t.references :report
      t.references :subject
      t.references :sub_subject
      t.text 	   :p_level
      t.text 	   :p_sub_level
      t.timestamps null: false
    end
  end
end
