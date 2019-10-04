class CreateMasterDays < ActiveRecord::Migration
  def change
    create_table :master_days do |t|

    	t.string :name

      t.timestamps null: false
    end
  end
end
