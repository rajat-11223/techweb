class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t| 


    	t.references	:academic_session
    	t.references	:student
    	t.references	:term
    	t.references	:user
    	t.string			:title
    	t.text				:summary
    	t.string			:report_type
    	t.string			:status
    	t.string			:phase_name
    	t.string			:lg_name
    	t.datetime		:submitted_at

      t.timestamps null: false
    end
  end
end
