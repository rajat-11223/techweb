module UnsetFlag
	@queue = :unset_flag_queue

	def self.perform
		Student.with_deleted.each do |stud|
			stud.temp_lg_user_id = false
			stud.temp_tg_user_id = false
			stud.temp_schedule_user_id = false 
			stud.save
		end
		
	end
end