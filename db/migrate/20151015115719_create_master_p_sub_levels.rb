class CreateMasterPSubLevels < ActiveRecord::Migration
  def change
    create_table :master_p_sub_levels do |t|

    	t.string 		:name
    	t.datetime 		:deleted_at

      t.timestamps null: false
    end
  end
end
