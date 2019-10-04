class CreateGlobalLoImportFiles < ActiveRecord::Migration
  def change
    create_table :global_lo_import_files do |t|

    	t.string 		:name
    	t.string 		:type
    	t.references 	:user
    	t.datetime		:deleted_at
    	

      t.timestamps null: false
    end
  end
end
