class CreateAcademicSessions < ActiveRecord::Migration
  def change
    create_table :academic_sessions do |t|

    	t.string		:name,			null: false
    	t.boolean		:is_current,	default: false
    	t.date			:start_date
    	t.date 			:end_date

      t.timestamps null: false
    end
  end
end
