class AddTitleToLo < ActiveRecord::Migration
  def change
  	  	  	add_column :student_learning_objectives,:title,:text
  	  	  	add_column :global_custom_objectives,:title,:text



  end
end
