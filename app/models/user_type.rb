class UserType < ActiveRecord::Base

	belongs_to :user
	belongs_to :master_user_type

end
