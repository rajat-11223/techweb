class ReportObservationEvidence < ActiveRecord::Base
	belongs_to :report_objective_observation
	belongs_to :student_learning_objective_observation_file, -> {with_deleted}

	 def show_evidence(size)

	self.evidence.url(size)

end 

def check_file_type

    if  evidence.content_type.in? ["image/jpg", "image/jpeg","image/pjpeg","image/png","image/x-png"]
			{:thumb => "200x200#" }
      
  else  evidence.content_type.in? ["video/mp4","video/quicktime","video/mov"]
{

   
  }
  end                        
end
end
