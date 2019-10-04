class CreateGlobalPivatsSublevels < ActiveRecord::Migration
  def change
    create_table :global_pivats_sublevels do |t|
    	t.references :global_pivats_objective
    	t.string    :alphabet
    	t.text			:description
  
    	t.datetime	:deleted_at
      t.timestamps null: false
    end
  end
end
