class LearningGroupPolicy < ApplicationPolicy


	def index?
		@current_user.role?("admin") || @current_user.role?("team-lead")
	end

end