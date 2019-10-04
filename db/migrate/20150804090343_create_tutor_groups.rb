class CreateTutorGroups < ActiveRecord::Migration
  def change
    create_table :tutor_groups do |t|

    	t.references	:academic_session
    	t.string		:name,						null: false
    	t.references	:user,						null: false

      t.timestamps null: false
    end
  end
end
