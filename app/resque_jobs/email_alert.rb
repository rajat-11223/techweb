module EmailAlert
	@queue = :email_alert_queue

	def self.perform(current_session,object_class,action_name,current_user)

		if action_name == 'temp_complete_learning_objective'
				
				AlertMailer.temp_complete_lo(object_id,current_session).deliver_later

		elsif action_name == "temp_decline_learning_objective"
			AlertMailer.temp_decline_learning_objective(object_id,current_session).deliver_later

		elsif action_name =="close_lo_learning_objective"

			@lo=StudentLearningObjective.find(object_id)
			@lo.focus_classes.each do |focus|
				focus=focus

				AlertMailer.close_lo_learning_objective(object_id,current_session,current_user,focus).deliver_later
			end

		end


	end
end