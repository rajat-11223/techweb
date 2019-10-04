class StudentLearningObjectiveFocusSubject < ActiveRecord::Base

	belongs_to :student_learning_objective

	belongs_to :user, -> {with_deleted}


	belongs_to :subject, -> {with_deleted}
	belongs_to :sub_subject, -> {with_deleted}

end
