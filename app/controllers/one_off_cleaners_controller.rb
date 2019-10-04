class OneOffCleanersController < ApplicationController

	# # Step 1

	# def set_achieved_dates

	# 	@student_los = StudentLearningObjective.all

	# 	@student_los.each do |lo|
	# 		if lo.is_completed
	# 			lo.achieved_date = Time.now
	# 			lo.save
	# 		end
	# 	end

	# end

	# # Step 2 - Check if GlobalPivatsObjectives changed to GlobalPivatsSublevels in database.

	# # Step 3

	# def set_lo_psublevels

	# 	@student_los = StudentLearningObjective.all
	# 	@student_los.each do |lo|
	# 		if lo.global_lo_type == "GlobalPivatsSublevel"
	# 			lo.p_sublevel = lo.global_lo.alphabet
	# 			lo.save
	# 		end
	# 	end
		
	# end

	# # Step 4 - Upload seed files of new PIVATS LOs

	# def set_new_lo_numbering_offset

	# 	# setting up Maths L2 offsets

	# 	@selected_los = StudentLearningObjective.where("global_lo_type = ? AND global_lo_id > ?", "GlobalPivatsSublevel", 1395)
	# 	@selected_los.each do |lo|
	# 		lo.global_lo_id = lo.global_lo_id + 5
	# 		lo.save
	# 	end		

	# 	# setting up English P3(i) offsets

	# 	@selected_los = StudentLearningObjective.where("global_lo_type = ? AND global_lo_id > ?", "GlobalPivatsSublevel", 415)
	# 	@selected_los.each do |lo|
	# 		lo.global_lo_id = lo.global_lo_id + 5
	# 		lo.save
	# 	end



	# end



end
