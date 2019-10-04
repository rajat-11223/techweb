class MasterTerm < ActiveRecord::Base
	has_many :terms

	def populate_start(school_session)

		if !self.terms.blank? && !self.terms.find_by(:academic_session_id => school_session).blank?

		return self.terms.find_by(:academic_session_id => school_session).start_date
		else
			""
		end
	end	

	def populate_end(school_session)

		if !self.terms.blank? && !self.terms.find_by(:academic_session_id => school_session).blank?
			return self.terms.find_by(:academic_session_id => school_session).end_date
		else
			""
		end
	end
end
