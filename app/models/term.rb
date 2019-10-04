require 'rake'
class Term < ActiveRecord::Base

	belongs_to :master_term
	belongs_to :academic_session


def populate_start(school_session)
	
	if !self.yearly_term.blank?
			return self.yearly_term.find_by(:school_session_id => school_session).start_date
	else
		none	
	end
	end	

def populate_end(school_session)
	if !self.yearly_term.blank?
		return self.yearly_term.find_by(:school_session_id => school_session).end_date
	else
		none
	end
end

def self.run_rake(task_name)

    # load File.join(Rails.root, 'lib', 'tasks', 'signout_all.rake')
    # Rake::Task[task_name].invoke
end
	
end
