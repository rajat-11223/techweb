class StudentLearningObjectiveObservationFile < ActiveRecord::Base

  acts_as_paranoid
  
	belongs_to :student_learning_objective
	belongs_to :student_learning_objective_observation
  has_one :report_observation_evidence
  has_one :report_objective_evidence
  has_one :report_subject_observation_evidence

  belongs_to   :original_observation, class_name: "StudentLearningObjectiveObservation", foreign_key: "original_obs_id"


		# has_attached_file :evidence,
  # 										:styles => {:thumb => "200x200#"}
 
  # validates_attachment_size           :evidence, :less_than => 10.megabytes 
  # validates_attachment_content_type   :evidence, 
  #                                     :content_type => [/\Aimage\/(jpg|jpeg|pjpeg|png|x-png)\z/,/^video\/(x-matroska|mov)/],
  #                                     :message => 'file type is not allowed (only jpeg/png images)'


#   has_attached_file :evidence, :styles => {
#     :thumb => {:format => 'jpg' }
#   }, :processors => [:transcoder]

#  validates_attachment_content_type   :evidence, 
#                                       :content_type => [/\Aimage\/(jpg|jpeg|pjpeg|png|x-png)\z/,/^video\/(x-matroska|mov)/],
#                                       :message => 'file type is not allowed (only jpeg/png images)'
 


has_attached_file :evidence, styles: lambda { |a| a.instance.check_file_type}, :default_url => "no_image.png"
validates_attachment_content_type   :evidence, 
                                    :content_type => [/\Aimage\/(jpg|jpeg|pjpeg|png|x-png)\z/,/^video\/(mp4|x-matroska|mov|quicktime|avi)/],
                                    :message => 'file type is not allowed'

# has_attached_file :evidence,:styles => {  processors: {:thumb => { :geometry => "160x120", :format => 'jpeg', :time => 10}, :processors => [:transcoder]}}
 
#  :styles => { 
#         :medium => {:geometry => "640x480", :format => 'flv'},
#         :thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10 }
#     }, :processors => [:transcoder]

# validates_attachment_content_type :evidence, :content_type => ["video/mp4", "video.mov", "video/mpeg","video/mpeg4", "image/jpg", "image/jpeg"]


 def show_evidence(size)

	self.evidence.url(size)

end    

def check_file_type

    if  evidence.content_type.in? ["image/jpg", "image/jpeg","image/pjpeg","image/png","image/x-png"]
			{:thumb => "200x200#" }
      
  else  evidence.content_type.in? ["video/mp4","video/quicktime","video/mov"]
{
 # has_attached_file :avatar, 
 #    :url => '/:class/:id/:style.:extension', 
             :thumb => { :geometry => "200x200#", :format => 'jpg', :time => 4 }
             # , :swallow_stderr => false
              
   
  }
  end                        
end

def check_content
  if  self.evidence_content_type.in? ["image/jpg", "image/jpeg","image/pjpeg","image/png","image/x-png"]
    return   ("<img src='#{self.evidence}'>").html_safe
  elsif self.evidence_content_type.in? ["video/mp4","video/quicktime","video/mov"]
    return   ("<img src='#{self.evidence(:thumb)}'>" '<i class="fa fa-2x fa-play-circle-o text-white play-fa-center-edit"></i>').html_safe
  else
    return ''
  end
end
end
