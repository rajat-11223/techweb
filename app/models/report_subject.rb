class ReportSubject < ActiveRecord::Base
	belongs_to :report

	belongs_to :subject, -> {with_deleted}
	belongs_to :sub_subject, -> {with_deleted}
	has_many :report_subject_observations
	has_many :report_subject_observation_evidences,through: :report_subject_observations

	belongs_to :user, -> {with_deleted}
end
