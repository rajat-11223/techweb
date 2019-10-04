class CreateStudentProfiles < ActiveRecord::Migration
  def change
    create_table :student_profiles do |t|
      t.references	:student
      t.string			:heading1
      t.string			:heading2
      t.string			:heading3
      t.string			:heading4
      t.timestamps null: false
    end
  end
end
