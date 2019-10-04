class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|

   	  t.string 		:fname,                      null: false, default: ""
      t.string 		:lname,                      null: false, default: ""
      t.string 		:sex,                   		  null: false, default: ""
      t.date   		:dob
      t.string 		:asdan_no,                 	null: false, default: ""
      t.string 		:upn_no,               		null: false, default: ""
      t.text 		:medical_information
      t.text 		:description               
      t.attachment 	:avatar
      t.boolean 	:temp_tutor_group,           default: false
      t.boolean 	:temp_lesson_group,          default: false
      t.datetime 	:deleted_at

      t.timestamps null: false
    end
  end
end
