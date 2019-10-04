# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# #
# # Examples:
# #
# #   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
# #   Mayor.create(name: 'Emanuel', city: cities.first)

# #-----
# MasterUserType.delete_all
# master_user_types = MasterUserType.create([ {id: 1, name: 'teacher', display_name: "Teacher", is_visible: true}, {id: 2, name: 'tutor', display_name: "Tutor", is_visible: true}, {id: 3, name: 'team-lead', display_name: "Team Leader", is_visible: true}, {id: 4, name: 'admin', display_name: "Admin", is_visible: true}])
# #-----

# #-----
# MasterCsdAxis.delete_all
# master_csd_axis = MasterCsdAxis.create([ {id: 1, name: 'prompting', display_name: "Prompting",min_value: '1',max_value:"10",position:"1", is_visible: true}, {id: 2, name: 'fluency', display_name: "Fluency",min_value: '1',max_value:"10",position:"2", is_visible: true}, {id: 3, name: 'maintenance', display_name: "Maintenance",min_value: '1',max_value:"10",position:"3",is_visible: true},{id:4, name: "generalisation",display_name: "Generalisation",min_value: '1',max_value:"10",position:"4", is_visible: true}])
# #-----

# #-----
# MasterTerm.delete_all
# THIS IS OLD. CHANGED IN RELEASE 2. master_terms = MasterTerm.create([ {id: 1, name: 'term-1', display_name: "Autumn", is_visible: true}, {id: 2, name: 'term-2', display_name: "Winter", is_visible: true}, {id: 3, name: 'term-3', display_name: "Spring", is_visible: true}])
# master_terms = MasterTerm.create([ {id: 1, name: 'term-1', display_name: "Autumn", is_visible: true}, {id: 2, name: 'term-2', display_name: "Spring", is_visible: true}, {id: 3, name: 'term-3', display_name: "Summer", is_visible: true}])
# #-----

# #-----
# MasterGrade.delete_all
# master_grades = MasterGrade.create([ {id: 1, value: 7, display_name: "7"}, {id: 2, value: 8, display_name: "8"}, {id: 3, value: 9, display_name: "9"}, {id: 4, value: 10, display_name: "10"}, {id: 5, value: 11, display_name: "11"}, {id: 6, value: 12, display_name: "12"}, {id: 7, value: 13, display_name: "13"}, {id: 8, value: 14, display_name: "14"}])
# #-----

# #-----
# MasterDay.delete_all
# master_days = MasterDay.create([{id:1, name: "Monday" },{id:2, name: "Tuesday" },{id:3, name: "Wednesday" },{id:4, name: "Thursday" },{id:5, name: "Friday" }])
# #-----

# #-----
# Slot.delete_all
# slots = Slot.create([
# 	{id: 1, academic_session_id: 1 , name: "Tutorial", is_taught_time: true, is_scheduled_time: false, start_time: "2000-01-01 09:15:00", end_time: "2000-01-01 10:00:00" }, 
# 	{id: 2, academic_session_id: 1 , name: "Lesson 1", is_taught_time: true, is_scheduled_time: true, start_time: "2000-01-01 10:00:00", end_time: "2000-01-01 10:50:00" }, 
# 	{id: 3, academic_session_id: 1 , name: "Break", is_taught_time: false, is_scheduled_time: false, start_time: "2000-01-01 10:50:00", end_time: "2000-01-01 11:10:00" }, 
# 	{id: 4, academic_session_id: 1 , name: "Lesson 2", is_taught_time: true, is_scheduled_time: true, start_time: "2000-01-01 11:10:00", end_time: "2000-01-01 12:00:00" }, 
# 	{id: 5, academic_session_id: 1 , name: "Lunch", is_taught_time: true, is_scheduled_time: true, start_time: "2000-01-01 12:00:00", end_time: "2000-01-01 12:45:00" }, 
# 	{id: 6, academic_session_id: 1 , name: "Play Time", is_taught_time: false, is_scheduled_time: false, start_time: "2000-01-01 12:45:00", end_time: "2000-01-01 13:30:00" }, 
# 	{id: 7, academic_session_id: 1 , name: "Registration", is_taught_time: false, is_scheduled_time: false, start_time: "2000-01-01 13:30:00", end_time: "2000-01-01 13:35:00" }, 
# 	{id: 8, academic_session_id: 1 , name: "Lesson 3", is_taught_time: true, is_scheduled_time: true, start_time: "2000-01-01 13:35:00", end_time: "2000-01-01 14:30:00" }, 
# 	{id: 9, academic_session_id: 1 , name: "Lesson 4", is_taught_time: true, is_scheduled_time: true, start_time: "2000-01-01 14:30:00", end_time: "2000-01-01 15:20:00" }, 
# 	{id: 10, academic_session_id: 1 , name: "Tutor Group", is_taught_time: false, is_scheduled_time: false, start_time: "2000-01-01 15:20:00", end_time: "2000-01-01 15:30:00" }
# 	])
# #-----



# # -----
# AcademicSession.delete_all
# # academic_sessions = AcademicSession.create([{id: 1,name: "2014-2015",is_current: false}, {id: 2,name: "2015-2016",is_current: true}])
# academic_sessions = AcademicSession.create([{id: 1,name: "2015-2016",is_current: true}])
# #----

# # -----
# Term.delete_all
# terms = Term.create([{id: 1, master_term_id: 1, academic_session_id: 1, start_date: "2015-09-01", end_date: "2015-12-24" }, {id: 2, master_term_id: 2, academic_session_id: 1, start_date: "2016-01-04", end_date: "2016-04-26" },{id: 3, master_term_id: 3, academic_session_id: 1, start_date: "2016-05-01", end_date: "2016-08-28" } ])
# #----

# #-----
# UserType.delete_all
# user_types = UserType.create([{id: 1, user_id: 1, master_user_type_id: 1}, {id: 2, user_id: 1, master_user_type_id: 2}, {id: 3, user_id: 1, master_user_type_id: 3},{id: 4, user_id: 1, master_user_type_id: 4}])
# #-----

# #------
# AnnualGrade.delete_all
# annual_grades = AnnualGrade.create([{id: 1,academic_session_id: 1,master_grade_id: 1},{id: 2,academic_session_id: 1,master_grade_id: 2},{id: 3,academic_session_id: 1,master_grade_id: 3},{id: 4,academic_session_id: 1,master_grade_id: 4},{id: 5,academic_session_id: 1,master_grade_id: 5},{id: 6,academic_session_id: 1,master_grade_id: 6},{id: 7,academic_session_id: 1,master_grade_id: 7},{id: 8,academic_session_id: 1,master_grade_id: 8}])
# #-----

# # -----
# Subject.delete_all
# subjects = Subject.create([{id: 1, name: "Lunch", is_lunch: true },{id: 2, name: "Tutor Group", is_tutorial: true },{id: 3, name: "PPA", is_ppa: true}])
# subjects = Subject.create([{id: 4, name: "English", is_pivats: true, position: 1},{id: 5, name: "Maths", is_pivats: true, position: 2},{id: 6, name: "Science", is_pivats: true, position: 4 },{id: 7, name: "PSD", is_pivats: true, position: 5 },{id: 8, name: "ICT", is_pivats: true, position: 3}])
# #----

# # -----
# SubSubject.delete_all
# sub_subjects = SubSubject.create([{id: 1, subject_id: 1, name: "Lunch", is_none: true}, {id: 2, subject_id: 2, name: "Tutor Group", is_tutorial: true, is_none: true}, {id: 3, subject_id: 3, name: "PPA", is_none: true}])
# sub_subjects = SubSubject.create([
# 	{id: 4, subject_id: 4, name: "Speaking and Listening (Listening)", position: 2},
# 	{id: 5, subject_id: 4, name: "Speaking and Listening (Speaking)", position: 1},
# 	{id: 6, subject_id: 4, name: "Reading", position: 3},
# 	{id: 7, subject_id: 4, name: "Writing", position: 4},

# 	{id: 8, subject_id: 5, name: "Using and Applying", position: 1},
# 	{id: 9, subject_id: 5, name: "Number (including data handling and calculations)", position: 2},
# 	{id: 10, subject_id: 5, name: "Shape, Space and Measures", position: 3},

# 	{id: 11, subject_id: 6, name: "Scientific Enquiry", position: 1},
# 	{id: 12, subject_id: 6, name: "Life Processes and Living Things", position: 2},
# 	{id: 13, subject_id: 6, name: "Materials and their Properties", position: 3},
# 	{id: 14, subject_id: 6, name: "Physical Processes", position: 4},

# 	{id: 15, subject_id: 7, name: "Interacting and Working with Others", position: 1},
# 	{id: 16, subject_id: 7, name: "Independent and Organisational Skills", position: 2},
# 	{id: 17, subject_id: 7, name: "Attention", position: 3},

# 	{id: 18, subject_id: 8, name: "Finding Things Out", position: 1},
# 	{id: 19, subject_id: 8, name: "Developing ideas and making things happen", position: 2},
# 	{id: 20, subject_id: 8, name: "Exchanging and sharing information", position: 3}



# 	])
# #----



#---
# AnnualGradePhase.delete_all
# annual_grade_phase=AnnualGradePhase.create([{id: 1,annual_grade_id: 1,phase_id: 1},{id: 2,annual_grade_id: 2,phase_id: 1},{id: 3,annual_grade_id: 3,phase_id: 1},{id: 4,annual_grade_id: 4,phase_id: 2},{id: 5,annual_grade_id: 5,phase_id: 2},{id: 6,annual_grade_id: 6,phase_id: 2},{id: 7,annual_grade_id: 7,phase_id: 3},{id: 8,annual_grade_id: 8,phase_id: 3},{id: 9,annual_grade_id: 9,phase_id: 3}])
#-----

#-----
# Phase.delete_all
# phase=Phase.create([{id:1,academic_session_id: 2,name: "lower school",user_id: 2},{id:2,academic_session_id: 2,name: "middle school",user_id:2},{id:3,academic_session_id: 2,name: "upper school",user_id:2}])
#-----


#-----
MasterPSubLevel.delete_all
master_p_sub_level = MasterPSubLevel.create([{id:1, name: "a"}, {id:2, name: "b"}, {id:3, name: "c"},{id:4, name: "d"}, {id:5, name: "e"}])
#-----

#pivats csv
GlobalPivatsObjective.reset_column_information
GlobalPivatsObjective.delete_all
GlobalPivatsSublevel.delete_all
x=0
y=0
last_row = nil

CSV.foreach('db/Science.csv',headers: true) do |row|
	if /^[a-z]/ === row[6] # sub level 
		y=y+1	
			GlobalPivatsSublevel.create({
																		id: 													y.to_i,
																		global_pivats_objective_id:   last_row.id,
																		description: 									row[5],
																		alphabet: 										row[6]
																	})


	else #Px row main table
		x=x+1
			last_row = GlobalPivatsObjective.create({
																								id: 													x.to_i,
																								subject_name: 								row[1],
																								subject_id: 									Subject.find_by(name: row[1]).id,
																								sub_subject_name: 						row[3],
																								sub_subject_id: 							SubSubject.find_by(name: row[3]).id,
																								description:  								row[5],
																								p_level: 											row[6]
																						})
	end
end

#pivats-english-speaking

x=GlobalPivatsObjective.last.id
y=GlobalPivatsSublevel.last.id
last_row = nil

CSV.foreach('db/Pivats-English-Speaking.csv',headers: true) do |row|
	if /^[a-z]/ === row[6] # sub level 
		y=y+1	

			GlobalPivatsSublevel.create({
																		id: 													y,
																		global_pivats_objective_id:   last_row.id,
																		description: 									row[5],
																		alphabet: 										row[6]
																	})


	else #Px row main table

		x=x+1
		
			last_row = GlobalPivatsObjective.create({
																								id: 													x,
																								subject_name: 								row[1],
																								subject_id: 									Subject.find_by(name: row[1]).id,
																								sub_subject_name: 						row[3],
																								sub_subject_id: 							SubSubject.find_by(name: row[3]).id,
																								description:  								row[5],
																								p_level: 											row[6]
																						})
	end
end

#end
#pivats-english-listning

x=GlobalPivatsObjective.last.id
y=GlobalPivatsSublevel.last.id
last_row = nil

CSV.foreach('db/Pivats-English-Listening.csv',headers: true) do |row|
	if /^[a-z]/ === row[6] # sub level 
		y=y+1	
			GlobalPivatsSublevel.create({
																		id: 													y.to_i,
																		global_pivats_objective_id:   last_row.id,
																		description: 									row[5],
																		alphabet: 										row[6]
																	})


	else #Px row main table
		
		x=x+1
			last_row = GlobalPivatsObjective.create({
																								id: 													x,
																								subject_name: 								row[1],
																								subject_id: 									Subject.find_by(name: row[1]).id,
																								sub_subject_name: 						row[3],
																								sub_subject_id: 							SubSubject.find_by(name: row[3]).id,
																								description:  								row[5],
																								p_level: 											row[6]
																						})
	end
end

#end

#pivats-english-reading

x=GlobalPivatsObjective.last.id
y=GlobalPivatsSublevel.last.id
last_row = nil

CSV.foreach('db/Pivats-English-Reading.csv',headers: true) do |row|
	if /^[a-z]/ === row[6] # sub level 
		y=y+1	
			GlobalPivatsSublevel.create({
																		id: 													y.to_i,
																		global_pivats_objective_id:   last_row.id,
																		description: 									row[5],
																		alphabet: 										row[6]
																	})


	else #Px row main table
		
		x=x+1
			last_row = GlobalPivatsObjective.create({
																								id: 													x,
																								subject_name: 								row[1],
																								subject_id: 									Subject.find_by(name: row[1]).id,
																								sub_subject_name: 						row[3],
																								sub_subject_id: 							SubSubject.find_by(name: row[3]).id,
																								description:  								row[5],
																								p_level: 											row[6]
																						})
	end
end

#end
#pivats-english-writing

x=GlobalPivatsObjective.last.id
y=GlobalPivatsSublevel.last.id
last_row = nil

CSV.foreach('db/Pivats-English-Writing.csv',headers: true) do |row|
	if /^[a-z]/ === row[6] # sub level 
		y=y+1	
			GlobalPivatsSublevel.create({
																		id: 													y.to_i,
																		global_pivats_objective_id:   last_row.id,
																		description: 									row[5],
																		alphabet: 										row[6]
																	})


	else #Px row main table
		
		x=x+1
			last_row = GlobalPivatsObjective.create({
																								id: 													x,
																								subject_name: 								row[1],
																								subject_id: 									Subject.find_by(name: row[1]).id,
																								sub_subject_name: 						row[3],
																								sub_subject_id: 							SubSubject.find_by(name: row[3]).id,
																								description:  								row[5],
																								p_level: 											row[6]
																						})
	end
end

#end

#pivats-PSD

x=GlobalPivatsObjective.last.id
y=GlobalPivatsSublevel.last.id
last_row = nil

CSV.foreach('db/PSD.csv',headers: true) do |row|
	if /^[a-z]/ === row[6] # sub level 
		y=y+1	
			GlobalPivatsSublevel.create({
																		id: 													y.to_i,
																		global_pivats_objective_id:   last_row.id,
																		description: 									row[5],
																		alphabet: 										row[6]
																	})


	else #Px row main table
		
		x=x+1
			last_row = GlobalPivatsObjective.create({
																								id: 													x,
																								subject_name: 								row[1],
																								subject_id: 									Subject.find_by(name: row[1]).id,
																								sub_subject_name: 						row[3],
																								sub_subject_id: 							SubSubject.find_by(name: row[3]).id,
																								description:  								row[5],
																								p_level: 											row[6]
																						})
	end
end

#end

#pivats-ICT

x=GlobalPivatsObjective.last.id
y=GlobalPivatsSublevel.last.id
last_row = nil

CSV.foreach('db/ICT.csv',headers: true) do |row|
	if /^[a-z]/ === row[6] # sub level 
		y=y+1	
			GlobalPivatsSublevel.create({
																		id: 													y.to_i,
																		global_pivats_objective_id:   last_row.id,
																		description: 									row[5],
																		alphabet: 										row[6]
																	})


	else #Px row main table
		
		x=x+1
			last_row = GlobalPivatsObjective.create({
																								id: 													x,
																								subject_name: 								row[1],
																								subject_id: 									Subject.find_by(name: row[1]).id,
																								sub_subject_name: 						row[3],
																								sub_subject_id: 							SubSubject.find_by(name: row[3]).id,
																								description:  								row[5],
																								p_level: 											row[6]
																						})
	end
end

#end

#Maths

x=GlobalPivatsObjective.last.id
y=GlobalPivatsSublevel.last.id
last_row = nil

CSV.foreach('db/Maths.csv',headers: true) do |row|
	if /^[a-z]/ === row[6] # sub level 
		y=y+1	
			GlobalPivatsSublevel.create({
																		id: 													y.to_i,
																		global_pivats_objective_id:   last_row.id,
																		description: 									row[5],
																		alphabet: 										row[6]
																	})


	else #Px row main table
		
		x=x+1
			last_row = GlobalPivatsObjective.create({
																								id: 													x,
																								subject_name: 								row[1],
																								subject_id: 									Subject.find_by(name: row[1]).id,
																								sub_subject_name: 						row[3],
																								sub_subject_id: 							SubSubject.find_by(name: row[3]).id,
																								description:  								row[5],
																								p_level: 											row[6]
																						})
	end
end

#end

#RFl
GlobalRflObjective.reset_column_information
GlobalRflObjective.delete_all
i=0
CSV.foreach('db/rfl.csv',headers: true) do |row|
		i=i+1	

			GlobalRflObjective.create({
																		id: 													i,
																		position: 										i,
																		description: 									row[0],
																		additional_text: 								row[1],
																
																	})
end


# MasterPLevel
MasterPLevel.reset_column_information
MasterPLevel.delete_all
i=0
CSV.foreach('db/p_levels.csv',headers: true) do |row|
		i=i+1	

			MasterPLevel.create({
																		id: 													i,
																		name: 											row[0],
																
																	})
end