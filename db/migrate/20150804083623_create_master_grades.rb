class CreateMasterGrades < ActiveRecord::Migration
  def change
    create_table :master_grades do |t|

    	t.integer :value
    	t.string  :display_name

      t.timestamps null: false
    end
  end
end
