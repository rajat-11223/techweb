Rails.application.routes.draw do

  devise_for :users, :controllers => {:invitations => 'users/invitations', :sessions => 'users/sessions', :passwords => 'users/passwords' }, :skip => [:registrations]        
  as :user do   
    # get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'    
    # put 'users/:id' => 'users/registrations#update', :as => 'user_registration'            
  root :to => "users/sessions#new"
  get '/users/sign_out' => 'devise/sessions#destroy' 
  end
    scope "/admin" do
      mount Resque::Server, :at => "/resque"
    end
# students
post "add_student" =>"students#add_student", as: :add_student_from_modal
post "edit_student_modal" =>"students#edit_student", as: :edit_student_from_modal
post "save_focus" =>"students#save_focus"
post "create_schedule_from_student_index" =>"students#create_schedule_from_student_index"

post "show_selected_lo_student_index" =>"students#show_selected_lo_student_index"
post "create_schedule_student_index" => "students#create_schedule_student_index", as: :create_schedule_student_index
post "show_focus_subject" => "students#show_focus_subject", as: :show_focus_subject
post "edit_schedule_student_show" => "students#edit_schedule_student_show", as: :edit_schedule_student_show
post "delete_schedule_student_show" => "students#delete_schedule_student_show", as: :delete_schedule_student_show
post "save_edit_schedule_student_show" => "students#save_edit_schedule_student_show"
get "download/" =>"observations#download"

post "edit_student_important_info" =>"students#edit_student_important_info", as: :edit_student_important_info
post "add_medical_info" => "students#add_medical_info" ,as: :add_medical_info
post "create_information" => "students#create_information" ,as: :create_information
post "update_medicalinfo" =>"students#update_medicalinfo" , as: :update_medicalinfo
post "save_medical_information" =>"students#save_medical_information", as: :save_medical_information
post "reactivate_student" =>"students#reactivate_student"
post "add_student_profile" =>"students#add_student_profile" , as: :add_student_profile
post "save_profile_data" =>"students#save_profile_data" , as: :save_profile_data

post "export_caspa_modal" => "students#show_caspa_selection"
get "export_caspa_data" => "students#export_caspa_data"
post "add_summary" =>"students#add_summary",as: :add_summary
post "save_lo_summary" => "students#save_lo_summary"
post "show_individual_evidence" => "observations#show_individual_evidence"  
get "student/:id/print" => "students#print_student_lo" , as: :print_student_lo



# end
# student_card
post "add_observation_student_card" =>"observations#add_observation_student_card", as: :add_observation_student_card
post "save_only_evidence" =>"observations#save_only_evidence"
# end
post "send_invite/:id" => "staff_profiles#send_invite" ,as: :send_invite
# tutor group
post "edit_group_from_table" =>"tutor_groups#edit_tutor_group", as: :edit_group
post "add_student_to_tutor_group_path/:id" =>"tutor_groups#add_student", as: :add_student
post "update_add_student_to_tutor_group_path" =>"tutor_groups#update_tutor_group_student", as: :update_tutor_group_student
post "remove_student_from_tutor_group_while_edit" =>"tutor_groups#remove_student_from_tutor_group_while_edit"
post "unique_tutor_name" =>"tutor_groups#unique_tutor_name"
post "update_unique_tutor_name" =>"tutor_groups#update_unique_tutor_name"

post "remove_student_to_tutor_group_path/:id" =>"tutor_groups#remove_student", as: :remove_student
post "reset_student" =>"tutor_groups#reset_student", as: :reset_student
post "new_tg_modal" =>"tutor_groups#new_tg_modal",as: :new_tg_modal

# end

#term
post 'terms_new_scheduled'=> "terms#terms_new_scheduled"
#end

# LO
post "open_learning_group_form_from_modal" => "learning_groups#open_learning_group_form_from_modal", as: :open_learning_group_form_from_modal
post "add_student_to_learning_group/:id" => "learning_groups#add_student_to_learning_group", as: :add_student_to_learning_group
post "remove_added_student_to_learning_group/:id" => "learning_groups#remove_added_student_to_learning_group", as: :remove_added_student_to_learning_group
post "edit_learning_group_from_index" => "learning_groups#edit_learning_group_from_index" ,as: :update_modal
post "update_added_student_while_editing" =>"learning_groups#update_added_student_while_editing", as: :update_added_student_while_editing
post "remove_student_from_learning_group_while_editing" =>"learning_groups#remove_student_from_learning_group_while_editing",as: :remove_student_from_learning_group_while_editing
post "reset_learning_student" =>"learning_groups#reset_learning_student", as: :reset_learning_student
post "unique_learning_name" =>"learning_groups#unique_learning_name"
post "update_unique_learning_name" =>"learning_groups#update_unique_learning_name"

# end

# Student LO
post "assign_new_learning_objective" =>"students#assign_new_learning_objective", as: :assign_new_learning_objective
post "add_focus_class_to_lo" =>"students#add_focus_class_to_lo", as: :add_focus_class_to_lo

post "save_rfl_learning_objective" => "students#save_rfl_learning_objective"
post "save_pivats_learning_objective" => "students#save_pivats_learning_objective"
post "save_custom_learning_objective" => "students#save_custom_learning_objective"
post "show_pivats_sub_subjects" =>"students#show_pivats_sub_subjects"
post "show_custom_sub_subjects" =>"students#show_custom_sub_subjects"
post "show_plevel_pivats" =>"students#show_plevel_pivats"
post "plevel_description/:id" =>"students#plevel_description" ,as: :plevel_description

post "edit_learning_objective" =>"students#edit_learning_objective" , as: :edit_learning_objective
patch "update_pivats_learning_objective" => "students#update_pivats_learning_objective"
post  "temp_complete_learning_objective" =>"students#temp_complete_learning_objective"
post  "temp_decline_learning_objective" =>"students#temp_decline_learning_objective"
post  "temp_accept_learning_objective" =>"students#temp_accept_learning_objective"
post  "close_lo_learning_objective" =>"students#close_lo_learning_objective" 
post  "reopen_lo_learning_objective" =>"students#reopen_lo_learning_objective" 
post  "unachieve_lo_learning_objective" =>"students#unachieve_lo_learning_objective" 
post  "delete_lo_learning_objective" =>"students#delete_lo_learning_objective" 

post "set_objective_achievement" => "students#set_objective_achievement", as: :set_objective_achievement
# end

# student lo observation

post "add_observation" =>"observations#add_observation", as: :add_observation
post  "save_observation" =>"observations#save_observation", as: :save_observation
post  "view_observation" =>"observations#view_observation", as: :view_observation
post  "edit_observation/:id" =>"observations#edit_observation", as: :edit_observation
post  "save_edit_observation" =>"observations#save_edit_observation", as: :save_edit_observation
post  "delete_observation/:id" =>"observations#delete_observation", as: :delete_observation
post  "change_file_flag" =>"observations#change_file_flag", as: :change_file_flag
post "show_evidence_from_modal" =>"observations#show_evidence_from_modal",as: :show_evidence_from_modal
post "hide_image_observation" => "observations#hide_image_observation"
post "assign_individual_observation" =>"observations#assign_individual_observation",as: :assign_individual_observation
post "save_assign_observation" =>"observations#assign_observation"
post "delete_individual_observation" =>"observations#delete_individual_observation"
post  "view_observation_staff" =>"observations#view_observation_staff", as: :view_observation_staff
post  "edit_observation_from_staff/:id" =>"observations#edit_observation_from_staff", as: :edit_observation_from_staff
post  "delete_observation_from_staff/:id" =>"observations#delete_observation_from_staff", as: :delete_observation_from_staff
# end

#schedule
post "reset_schedule_student" =>"schedules#reset_schedule_student"
post "open_create_schedule_modal"=>"schedules#open_create_schedule_modal", as: :open_create_schedule_modal
post "update_schedule_modal"=>"schedules#update_schedule_modal", as: :update_schedule_modal
post "update_schedule_subject_change" =>"schedules#update_schedule_subject_change"
post "update_schedule_subsubject_change" =>"schedules#update_schedule_subsubject_change"
post "update_schedule_lo" =>"schedules#update_schedule_lo"
post "open_create_schedule_lunch_modal"=>"schedules#open_create_schedule_lunch_modal", as: :open_create_schedule_lunch_modal
post "open_edit_schedule_modal" => "schedules#open_edit_schedule_modal"
get "remove_schedule_slot" => "schedules#remove_schedule_slot", as: :remove_schedule_slot
post "on_subject_change_show_its_sub_subjects_while_creating_schedule" =>"schedules#on_subject_change_show_its_sub_subjects_while_creating_schedule"
post "on_learning_group_change_show_students_while_creating_schedule" =>"schedules#on_learning_group_change_show_students_while_creating_schedule"
post "add_lg_student_schedule" => "schedules#add_lg_student_schedule", as: :add_lg_student_schedule
post "remove_lg_student_schedule"=> "schedules#remove_lg_student_schedule",as: :remove_lg_student_schedule
post "verify_sub_subject" => "schedules#verify_sub_subject", as: :verify_sub_subject
post "delete_schedule" => "schedules#delete_schedule"
post "update_main_tutorial_schedule" =>"schedules#update_main_tutorial_schedule"
patch "save_updated_main_tutorial" => "schedules#save_updated_main_tutorial"

post "on_tg_select_show_students_while_creating_main_tutorial_schedule" =>"schedules#on_tg_select_show_students_while_creating_main_tutorial_schedule"
# post "open_create_schedule_main_tutorial_modal"=>"schedules#open_create_schedule_main_tutorial_modal", as: :open_create_schedule_main_tutorial_modal
post "create_tutorial_schedule_show_ppa_or_tg"=>"schedules#create_tutorial_schedule_show_ppa_or_tg", as: :open_create_schedule_main_tutorial_modal
post "clone_schedule" => "schedules#clone_schedule"
# post "remove_lg_student_update_schedule"=> "schedules#remove_lg_student_update_schedule",as: :remove_lg_student_update_schedule
# new
post 'create_tutorial_schedule' => 'schedules#create_tutorial_schedule'
post 'select_lg_tg' => 'schedules#select_lg_tg'
post "add_tg_student_schedule" => "schedules#add_tg_student_schedule", as: :add_tg_student_schedule
post "remove_tg_student_schedule" => "schedules#remove_tg_student_schedule", as: :remove_tg_student_schedule

#end

# subjects
post "/create_core_subject" =>"subjects#create_core_subject"
get "/subject/delete_sub_subject/:id"=> "subjects#delete_sub_subject", as: :sub_delete
post "/subject/edit_subject"=> "subjects#edit_subject", as: :edit_subject_modal
post "edit_core_subject"=> "subjects#edit_core_subject", as: :edit_core_subject
post "/subjects/sub_subjects" =>"subjects#sub_subjects"
# end

post "/yearly_terms/new_scheduled"=> "yearly_terms#new_scheduled"


# staff
post "edit_staff_from_table" =>"staff_profiles#edit_staff_profile", as: :edit_staff_profile
post "open_new_staff_modal_from_index" =>"staff_profiles#open_new_staff_modal_from_index", as: :new_staff

post "unique_user_email" => 'staff_profiles#unique_user_email'
post "update_unique_user_email" => 'staff_profiles#update_unique_user_email'
post "reactivate_user" =>"staff_profiles#reactivate_user"
post "change_user_pwd" =>"staff_profiles#change_user_pwd"
post "save_new_pwd" =>"staff_profiles#save_new_pwd"
# end

#reports

post "reports_add_evidence" => "reports#reports_add_evidence"
post "save_report_evidence" => "reports#save_report_evidence"
post "save_sort_evidence" => "reports#save_sort_evidence"
post "save_observation_sort" => "reports#save_observation_sort"
post "evidence_close" => "reports#evidence_close"
post "observation_close" => "reports#observation_close"
post "save_report_summary" =>"reports#save_report_summary"
post "save_observation_summary" =>"reports#save_observation_summary"
post "save_report_plevel" => "reports#save_report_plevel"
post "save_report_sublevel" => "reports#save_report_sublevel"
post "report_subject_add_evidence" =>"reports#report_subject_add_evidence"
post "save_report_subject_evidence" => "reports#save_report_subject_evidence"
post "save_report_sort_evidence" =>"reports#save_report_sort_evidence"
post "save_reportsubject_plevel_one" =>"reports#save_reportsubject_plevel_one"
post "save_reportsubject_plevel_two" =>"reports#save_reportsubject_plevel_two"
post "save_reportsubject_psublevel_one" =>"reports#save_reportsubject_psublevel_one"
post "save_reportsubject_psublevel_two" =>"reports#save_reportsubject_psublevel_two"
post "save_reportsubject_summary" =>"reports#save_reportsubject_summary"
post "save_reportsubjectobservation_summary" =>"reports#save_reportsubjectobservation_summary"
post "curriculum_evidence_close" =>"reports#curriculum_evidence_close"
post "report_download/:id" =>"reports#report_download",as: :report_download

post "report_send_reminder" =>"reports#report_send_reminder"
post "report_request_amend" =>"reports#report_request_amend"
post "save_request_amend" =>"reports#save_request_amend"
post "save_reminder" =>"reports#save_reminder"


post "admin_report_send_reminder" =>"reports#admin_report_send_reminder"
post "admin_report_request_amend" =>"reports#admin_report_request_amend"
post "report_send_parent" =>"reports#report_send_parent"

post "send_for_approval" =>"reports#send_for_approval",as: :send_for_approval

post "approve_report" =>"reports#approve_report",as: :approve_report
post "send_back_unapproved" =>"reports#send_back_unapproved",as: :send_back_unapproved
post "send_report_parents" =>"reports#send_report_parents",as: :send_report_parents

post "unapprove_report" =>"reports#unapprove_report",as: :unapprove_report

post "admin_send_reminder" =>"reports#admin_send_reminder"
post "report_delete" =>"reports#report_delete"
post "save_curriculum_sort" =>"reports#save_curriculum_sort"
post "curriculum_observation_close" => "reports#curriculum_observation_close"
post "report_play_video" =>"reports#report_play_video",as: :report_play_video
post "change_lo_status" => "reports#change_lo_status", as: :change_lo_status
# 121926299
post "set_report_objective_achievement" => "reports#set_report_objective_achievement", as: :set_report_objective_achievement
# end
#end
resources :reports
resources :students
resources :staff_profiles, :path => 'staff', as: :staff
resources :searches, :path => 'search', as: :search, :only => [:index,:create]

resources :homes, :only => [:index], path: 'home'
  scope 'admin' do
    resources :subjects, :only => [:index,:destroy,:update,:create]
    resources :schedules

    resources :terms,:only => [:index,:destroy,:update,:create]
    resources :tutor_groups,:only => [:index,:destroy,:update,:create]
    resources :learning_groups,:only => [:index,:destroy,:update,:create]
    resources :phases
  end

  get '/404' => 'errors#not_found'
  get '/422' => 'errors#unacceptable'
  get '/500' => 'errors#internal_error'

  get '/application/autocomplete' => "application#autocomplete"
  get '/student_report/:id' => "reports#student_report", as: :student_report 
  post '/change_timeline_state' => "application#change_timeline_state"
  # post '/search' => "application#search"
  # get '/results' => "application"
  get '/annual_closure' => 'annual_closure#index'
  get '/do_annual_closure' => 'annual_closure#annual_closure', as: :perform_annual_closure 

# get "XXXone_off_set_achieved_datesXXX" => 'one_off_cleaners#set_achieved_dates'
# get "XXXone_off_set_lo_psublevelsXXX" => 'one_off_cleaners#set_lo_psublevels'
# get "XXXone_off_set_new_lo_numbering_offsetXXX" => 'one_off_cleaners#set_new_lo_numbering_offset'
get "XXXadd_term_obs" => "observations#XXXadd_term_obs"
  # post 'tutor_groups/students' => 'tutor_groups#create_tutor_group_students', as: :tutor_group_students



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
