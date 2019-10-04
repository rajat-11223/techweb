class ReportCoreSubject < ActiveRecord::Base
	belongs_to :report
	belongs_to :subject, -> {with_deleted} #needed?
	belongs_to :sub_subject
end
