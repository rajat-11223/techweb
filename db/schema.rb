# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20191004052220) do

  create_table "academic_sessions", force: :cascade do |t|
    t.string   "name",       limit: 255,                 null: false
    t.boolean  "is_current", limit: 1,   default: false
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "alerts", force: :cascade do |t|
    t.string   "alert_type",         limit: 255
    t.integer  "object_entity_id",   limit: 4
    t.string   "object_entity_type", limit: 255
    t.integer  "target_entity_id",   limit: 4
    t.string   "target_entity_type", limit: 255
    t.text     "alert_text",         limit: 65535
    t.text     "alert_url",          limit: 65535
    t.boolean  "is_notification",    limit: 1,     default: true
    t.boolean  "is_email",           limit: 1,     default: false
    t.boolean  "is_manual",          limit: 1,     default: false
    t.datetime "deleted_at"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "annual_grade_phases", force: :cascade do |t|
    t.integer  "annual_grade_id", limit: 4
    t.integer  "phase_id",        limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "annual_grade_students", force: :cascade do |t|
    t.integer  "annual_grade_id", limit: 4
    t.integer  "student_id",      limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "is_pfc",          limit: 1, default: false
  end

  create_table "annual_grades", force: :cascade do |t|
    t.integer  "academic_session_id", limit: 4
    t.integer  "master_grade_id",     limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, length: {"slug"=>70, "sluggable_type"=>nil, "scope"=>70}, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", length: {"slug"=>140, "sluggable_type"=>nil}, using: :btree
  add_index "friendly_id_slugs", ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id", using: :btree

  create_table "global_custom_objectives", force: :cascade do |t|
    t.string   "subject_name",     limit: 255
    t.integer  "subject_id",       limit: 4
    t.string   "sub_subject_name", limit: 255
    t.integer  "sub_subject_id",   limit: 4
    t.text     "description",      limit: 65535
    t.string   "p_level",          limit: 255
    t.integer  "p_level_position", limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "title",            limit: 65535
    t.text     "p_sublevel",       limit: 65535
  end

  create_table "global_lo_import_files", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "type",       limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "global_pivats_objectives", force: :cascade do |t|
    t.integer  "global_lo_import_file_id", limit: 4
    t.string   "subject_name",             limit: 255
    t.integer  "subject_id",               limit: 4
    t.string   "sub_subject_name",         limit: 255
    t.integer  "sub_subject_id",           limit: 4
    t.text     "description",              limit: 65535
    t.string   "p_level",                  limit: 255
    t.integer  "p_level_position",         limit: 4
    t.text     "e",                        limit: 65535
    t.text     "d",                        limit: 65535
    t.text     "c",                        limit: 65535
    t.text     "b",                        limit: 65535
    t.text     "a",                        limit: 65535
    t.datetime "deleted_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "global_pivats_sublevels", force: :cascade do |t|
    t.integer  "global_pivats_objective_id", limit: 4
    t.string   "alphabet",                   limit: 255
    t.text     "description",                limit: 65535
    t.datetime "deleted_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "global_rfl_objectives", force: :cascade do |t|
    t.integer  "global_lo_import_file_id", limit: 4
    t.integer  "position",                 limit: 4
    t.text     "description",              limit: 65535
    t.datetime "deleted_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.text     "additional_text",          limit: 65535
  end

  create_table "learning_group_students", force: :cascade do |t|
    t.integer  "learning_group_id",   limit: 4
    t.integer  "student_id",          limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "academic_session_id", limit: 4
  end

  create_table "learning_groups", force: :cascade do |t|
    t.integer  "academic_session_id", limit: 4
    t.integer  "user_id",             limit: 4
    t.string   "name",                limit: 255,                     null: false
    t.string   "color",               limit: 255, default: "#000000"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.datetime "deleted_at"
  end

  create_table "master_csd_axis", force: :cascade do |t|
    t.string   "name",         limit: 255, null: false
    t.string   "display_name", limit: 255, null: false
    t.string   "min_value",    limit: 255, null: false
    t.string   "max_value",    limit: 255, null: false
    t.integer  "position",     limit: 4
    t.boolean  "is_visible",   limit: 1,   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "master_days", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "master_grades", force: :cascade do |t|
    t.integer  "value",        limit: 4
    t.string   "display_name", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "master_p_levels", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "master_p_sub_levels", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "master_terms", force: :cascade do |t|
    t.string   "name",         limit: 255, null: false
    t.string   "display_name", limit: 255, null: false
    t.boolean  "is_visible",   limit: 1,   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "master_user_types", force: :cascade do |t|
    t.string   "name",         limit: 255, null: false
    t.string   "display_name", limit: 255, null: false
    t.boolean  "is_visible",   limit: 1,   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "phases", force: :cascade do |t|
    t.integer  "academic_session_id", limit: 4
    t.string   "name",                limit: 255, null: false
    t.integer  "user_id",             limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "report_core_subjects", force: :cascade do |t|
    t.integer  "report_id",      limit: 4
    t.integer  "subject_id",     limit: 4
    t.integer  "sub_subject_id", limit: 4
    t.text     "p_level",        limit: 65535
    t.text     "p_sub_level",    limit: 65535
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "report_objective_evidences", force: :cascade do |t|
    t.integer  "report_objective_id",                            limit: 4
    t.integer  "student_learning_objective_observation_file_id", limit: 4
    t.integer  "position",                                       limit: 4
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
  end

  create_table "report_objective_observations", force: :cascade do |t|
    t.integer  "report_objective_id",                       limit: 4
    t.integer  "student_learning_objective_id",             limit: 4
    t.integer  "student_learning_objective_observation_id", limit: 4
    t.integer  "user_id",                                   limit: 4
    t.integer  "subject_id",                                limit: 4
    t.integer  "sub_subject_id",                            limit: 4
    t.datetime "create_date"
    t.text     "summary",                                   limit: 65535
    t.integer  "position",                                  limit: 4
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "summary_subject_name",                      limit: 255
    t.datetime "deleted_at"
  end

  create_table "report_objectives", force: :cascade do |t|
    t.integer  "report_id",                     limit: 4
    t.integer  "student_learning_objective_id", limit: 4
    t.integer  "subject_id",                    limit: 4
    t.integer  "sub_subject_id",                limit: 4
    t.string   "p_level",                       limit: 255
    t.date     "assigned_date"
    t.date     "target_date"
    t.text     "summary",                       limit: 65535
    t.integer  "position",                      limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "is_completed",                  limit: 4
    t.text     "p_sublevel",                    limit: 65535
    t.string   "lo_status",                     limit: 255
  end

  create_table "report_observation_achievements", force: :cascade do |t|
    t.integer  "report_objective_id",           limit: 4
    t.integer  "student_learning_objective_id", limit: 4
    t.integer  "master_csd_axis_id",            limit: 4
    t.integer  "achievement_value",             limit: 4
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "baseline_value",                limit: 4
    t.integer  "target_value",                  limit: 4
  end

  create_table "report_observation_evidences", force: :cascade do |t|
    t.integer  "report_objective_observation_id",                limit: 4
    t.integer  "student_learning_objective_observation_file_id", limit: 4
    t.text     "summary",                                        limit: 65535
    t.integer  "position",                                       limit: 4
    t.datetime "created_at",                                                                  null: false
    t.datetime "updated_at",                                                                  null: false
    t.boolean  "on_observation",                                 limit: 1,     default: true
  end

  create_table "report_subject_observation_evidences", force: :cascade do |t|
    t.integer  "report_subject_observation_id",                  limit: 4
    t.integer  "student_learning_objective_observation_file_id", limit: 4
    t.boolean  "on_observation",                                 limit: 1, default: true
    t.integer  "position",                                       limit: 4
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
  end

  create_table "report_subject_observations", force: :cascade do |t|
    t.integer  "report_subject_id",                         limit: 4
    t.integer  "student_learning_objective_id",             limit: 4
    t.integer  "student_learning_objective_observation_id", limit: 4
    t.integer  "user_id",                                   limit: 4
    t.integer  "subject_id",                                limit: 4
    t.integer  "sub_subject_id",                            limit: 4
    t.text     "summary",                                   limit: 65535
    t.integer  "position",                                  limit: 4
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.datetime "deleted_at"
  end

  create_table "report_subjects", force: :cascade do |t|
    t.integer  "report_id",                     limit: 4
    t.integer  "student_learning_objective_id", limit: 4
    t.integer  "user_id",                       limit: 4
    t.integer  "subject_id",                    limit: 4
    t.integer  "sub_subject_id",                limit: 4
    t.string   "p_level_one",                   limit: 255
    t.string   "p_level_two",                   limit: 255
    t.string   "p_sublevel_one",                limit: 255
    t.string   "p_sublevel_two",                limit: 255
    t.boolean  "is_completd",                   limit: 1,     default: false
    t.text     "summary",                       limit: 65535
    t.integer  "position",                      limit: 4
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "academic_session_id", limit: 4
    t.integer  "student_id",          limit: 4
    t.integer  "term_id",             limit: 4
    t.integer  "user_id",             limit: 4
    t.string   "title",               limit: 255
    t.text     "summary",             limit: 65535
    t.string   "report_type",         limit: 255
    t.string   "status",              limit: 255
    t.string   "phase_name",          limit: 255
    t.string   "lg_name",             limit: 255
    t.datetime "submitted_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "tutor_id",            limit: 4
    t.string   "slug",                limit: 255
  end

  add_index "reports", ["slug"], name: "index_reports_on_slug", unique: true, using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "slot_schedule_students", force: :cascade do |t|
    t.integer  "slot_schedule_id",      limit: 4
    t.integer  "student_id",            limit: 4
    t.integer  "associated_group_id",   limit: 4
    t.string   "associated_group_type", limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "slot_id",               limit: 4
    t.integer  "term_id",               limit: 4
    t.integer  "master_day_id",         limit: 4
  end

  create_table "slot_schedules", force: :cascade do |t|
    t.integer  "slot_id",             limit: 4
    t.integer  "term_id",             limit: 4
    t.integer  "master_day_id",       limit: 4
    t.integer  "subject_id",          limit: 4
    t.integer  "sub_subject_id",      limit: 4
    t.integer  "user_id",             limit: 4
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "academic_session_id", limit: 4
    t.integer  "learning_group_id",   limit: 4, default: 0
    t.integer  "tutor_group_id",      limit: 4, default: 0
  end

  create_table "slots", force: :cascade do |t|
    t.integer  "academic_session_id", limit: 4
    t.string   "name",                limit: 255
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "is_taught_time",      limit: 1,   default: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.boolean  "is_scheduled_time",   limit: 1,   default: false
  end

  create_table "student_important_infos", force: :cascade do |t|
    t.integer  "student_id",  limit: 4
    t.integer  "user_id",     limit: 4
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "student_learning_objective_achievements", force: :cascade do |t|
    t.integer  "student_learning_objective_observation_id", limit: 4
    t.integer  "student_learning_objective_id",             limit: 4
    t.integer  "master_csd_axis_id",                        limit: 4
    t.integer  "achievement_value",                         limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "student_learning_objective_focus_subjects", force: :cascade do |t|
    t.integer  "student_learning_objective_id", limit: 4
    t.integer  "subject_id",                    limit: 4
    t.integer  "sub_subject_id",                limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "academic_session_id",           limit: 4
    t.integer  "term_id",                       limit: 4
    t.integer  "user_id",                       limit: 4
  end

  create_table "student_learning_objective_observation_files", force: :cascade do |t|
    t.integer  "student_learning_objective_observation_id", limit: 4
    t.string   "evidence_file_name",                        limit: 255
    t.string   "evidence_content_type",                     limit: 255
    t.integer  "evidence_file_size",                        limit: 4
    t.datetime "evidence_updated_at"
    t.datetime "deleted_at"
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.boolean  "file_flag",                                 limit: 1,   default: false
    t.integer  "original_obs_id",                           limit: 4
  end

  create_table "student_learning_objective_observations", force: :cascade do |t|
    t.integer  "student_learning_objective_id", limit: 4
    t.integer  "user_id",                       limit: 4
    t.integer  "subject_id",                    limit: 4
    t.integer  "sub_subject_id",                limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.text     "description",                   limit: 65535
    t.date     "date"
    t.integer  "student_id",                    limit: 4
    t.boolean  "is_summary",                    limit: 1,     default: false
    t.string   "summary_subject_name",          limit: 255
    t.integer  "term_id",                       limit: 4
    t.integer  "academic_session_id",           limit: 4
  end

  create_table "student_learning_objective_targets", force: :cascade do |t|
    t.integer  "student_learning_objective_id", limit: 4
    t.integer  "master_csd_axis_id",            limit: 4
    t.integer  "baseline_value",                limit: 4
    t.integer  "target_value",                  limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "student_learning_objectives", force: :cascade do |t|
    t.integer  "student_id",            limit: 4
    t.integer  "academic_session_id",   limit: 4
    t.integer  "term_id",               limit: 4
    t.integer  "subject_id",            limit: 4
    t.integer  "sub_subject_id",        limit: 4
    t.integer  "global_lo_id",          limit: 4
    t.string   "global_lo_type",        limit: 255
    t.text     "description",           limit: 65535
    t.string   "p_level",               limit: 255
    t.date     "assigned_date"
    t.date     "target_date"
    t.boolean  "is_completed",          limit: 1,     default: false
    t.boolean  "is_closed",             limit: 1,     default: false
    t.datetime "deleted_at"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.boolean  "temp_complete",         limit: 1,     default: false
    t.integer  "user_id",               limit: 4
    t.integer  "temp_complete_user_id", limit: 4
    t.text     "title",                 limit: 65535
    t.string   "p_sublevel",            limit: 255
    t.date     "achieved_date"
  end

  create_table "student_profiles", force: :cascade do |t|
    t.integer  "student_id", limit: 4
    t.string   "heading1",   limit: 255
    t.string   "heading2",   limit: 255
    t.string   "heading3",   limit: 255
    t.string   "heading4",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "students", force: :cascade do |t|
    t.string   "fname",                 limit: 255,   default: "",    null: false
    t.string   "lname",                 limit: 255,   default: "",    null: false
    t.string   "sex",                   limit: 255,   default: "",    null: false
    t.date     "dob"
    t.string   "asdan_no",              limit: 255,   default: "",    null: false
    t.string   "upn_no",                limit: 255,   default: "",    null: false
    t.text     "medical_information",   limit: 65535
    t.text     "description",           limit: 65535
    t.string   "avatar_file_name",      limit: 255
    t.string   "avatar_content_type",   limit: 255
    t.integer  "avatar_file_size",      limit: 4
    t.datetime "avatar_updated_at"
    t.boolean  "temp_tutor_group",      limit: 1,     default: false
    t.boolean  "temp_lesson_group",     limit: 1,     default: false
    t.datetime "deleted_at"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "temp_lg_user_id",       limit: 4,     default: 0
    t.integer  "temp_tg_user_id",       limit: 4,     default: 0
    t.integer  "temp_schedule_user_id", limit: 4,     default: 0
  end

  create_table "sub_subjects", force: :cascade do |t|
    t.integer  "subject_id",   limit: 4
    t.string   "name",         limit: 255,                 null: false
    t.string   "display_name", limit: 255
    t.boolean  "is_core",      limit: 1,   default: false
    t.boolean  "is_pfc",       limit: 1,   default: false
    t.boolean  "is_tutorial",  limit: 1,   default: false
    t.boolean  "is_none",      limit: 1,   default: false
    t.integer  "position",     limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "level_count",  limit: 4,   default: 0
    t.string   "l1_sub_name",  limit: 255
    t.string   "l2_sub_name",  limit: 255
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "name",         limit: 255,                 null: false
    t.string   "display_name", limit: 255
    t.boolean  "is_pfc",       limit: 1,   default: false
    t.boolean  "is_ppa",       limit: 1,   default: false
    t.boolean  "is_core",      limit: 1,   default: false
    t.integer  "position",     limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "is_lunch",     limit: 1,   default: false
    t.boolean  "is_pivats",    limit: 1,   default: false
    t.boolean  "is_tutorial",  limit: 1,   default: false
  end

  create_table "summary_learning_objective_achievements", force: :cascade do |t|
    t.integer  "student_learning_objective_observation_id", limit: 4
    t.integer  "student_learning_objective_id",             limit: 4
    t.integer  "master_csd_axis_id",                        limit: 4
    t.integer  "achievement_value",                         limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "summary_learning_objectives", force: :cascade do |t|
    t.integer  "summary_obs_id",  limit: 4
    t.integer  "original_obs_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "terms", force: :cascade do |t|
    t.integer  "master_term_id",      limit: 4
    t.integer  "academic_session_id", limit: 4
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.boolean  "clone_flag",          limit: 1, default: false
  end

  create_table "tutor_group_students", force: :cascade do |t|
    t.integer  "tutor_group_id",      limit: 4
    t.integer  "student_id",          limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "academic_session_id", limit: 4
  end

  create_table "tutor_groups", force: :cascade do |t|
    t.integer  "academic_session_id", limit: 4
    t.string   "name",                limit: 255, null: false
    t.integer  "user_id",             limit: 4,   null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.datetime "deleted_at"
  end

  create_table "user_types", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.integer  "master_user_type_id", limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,   default: "",    null: false
    t.string   "encrypted_password",     limit: 255,   default: ""
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "fname",                  limit: 255,   default: "",    null: false
    t.string   "lname",                  limit: 255,   default: "",    null: false
    t.string   "isd_code",               limit: 255,   default: "",    null: false
    t.string   "home_phone",             limit: 255,   default: "",    null: false
    t.string   "mobile_phone",           limit: 255,   default: "",    null: false
    t.text     "description",            limit: 65535
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size",       limit: 4
    t.datetime "avatar_updated_at"
    t.datetime "deleted_at"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",       limit: 4
    t.integer  "invited_by_id",          limit: 4
    t.string   "invited_by_type",        limit: 255
    t.integer  "invitations_count",      limit: 4,     default: 0
    t.boolean  "timeline_minimized",     limit: 1,     default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
