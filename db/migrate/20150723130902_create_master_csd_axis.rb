class CreateMasterCsdAxis < ActiveRecord::Migration
  def change
    create_table :master_csd_axis do |t|
    	t.string		:name,						null: false
    	t.string		:display_name,		null: false
    	t.string    :min_value,				null: false
    	t.string    :max_value,				null: false
    	t.integer   :position
    	t.boolean		:is_visible,			null: false
      t.timestamps null: false
    end
  end
end
