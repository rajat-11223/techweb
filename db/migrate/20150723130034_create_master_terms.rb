class CreateMasterTerms < ActiveRecord::Migration
  def change
    create_table :master_terms do |t|
    	
    	t.string		:name,						null: false
    	t.string		:display_name,		null: false
    	t.boolean		:is_visible,			null: false

      t.timestamps null: false
    end
  end
end
