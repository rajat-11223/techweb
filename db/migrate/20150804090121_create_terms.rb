class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|

    	t.references 	:master_term
    	t.references 	:academic_session
    	t.date			:start_date
    	t.date			:end_date

      t.timestamps null: false
    end
  end
end
