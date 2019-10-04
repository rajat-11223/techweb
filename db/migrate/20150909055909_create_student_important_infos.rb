class CreateStudentImportantInfos < ActiveRecord::Migration
  def change
    create_table :student_important_infos do |t|

    	t.references	:student
    	t.references	:user
    	t.text			:description

      t.timestamps null: false
    end
  end
end
