class CreateLearningGroups < ActiveRecord::Migration
  def change
    create_table :learning_groups do |t|

    	t.references	:academic_session
    	t.references :user
    	t.string		:name,						null: false
    	t.string		:color

      t.timestamps null: false
    end
  end
end
