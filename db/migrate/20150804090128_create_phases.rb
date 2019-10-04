class CreatePhases < ActiveRecord::Migration
  def change
    create_table :phases do |t|

    	t.references	:academic_session
    	t.string		:name,				null: false
    	t.references	:user
    	
      t.timestamps null: false
    end
  end
end
