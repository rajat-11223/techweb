class CreateStudentLearningObjectives < ActiveRecord::Migration
  def change
    create_table :student_learning_objectives do |t|

    	t.references 		:student
    	t.references		:academic_session
    	t.references 		:term
    	t.references 		:subject
    	t.references 		:sub_subject
    	t.integer 			:global_lo_id
    	t.string 			:global_lo_type
    	t.text				:description
    	t.string			:p_level
    	t.date				:assigned_date
    	t.date				:target_date
    	t.boolean			:is_completed,     default: false
    	t.boolean			:is_closed,        default: false
    	t.datetime			:deleted_at


      t.timestamps null: false
    end
  end
end
