class CreateUserTypes < ActiveRecord::Migration
  def change
    create_table :user_types do |t|

    	t.references :user
    	t.references :master_user_type

      t.timestamps null: false
    end
  end
end
