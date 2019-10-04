class Alert < ActiveRecord::Base

  include Rails.application.routes.url_helpers  

  belongs_to :object_entity, polymorphic: true

	def generate_new(type, object_id, object_class, target_id, target_class)
    # @alert = Alert.new
    self.alert_type = type

    self.object_entity_id = object_id
    self.object_entity_type = object_class
    self.target_entity_id = target_id
    self.target_entity_type = target_class

    # Business rules
    if type == "New Learning Objective"
      self.alert_text = "#{Student.find(object_id).name} needs a new Learning Objective"
      self.alert_url = "#{student_path(object_id)}" + "#tab_objectives"

    elsif type == "Learning Objective Inactivity"
      self.alert_text = "It’s been a while since there was an observation for #{Student.find(object_id).name}'s Learning Objective."
      self.alert_url = "#{student_path(object_id)}" + "#tab_objectives"
      self.is_email = true

    elsif type == "Schedule Conflict"
      self.alert_text = "#{Student.find(object_id).name} has a schedule conflict."
      self.alert_url = "#{student_path(object_id)}" + "#tab_schedule"
      
    elsif type == "Unscheduled Time"
      self.alert_text = "#{Student.find(object_id).name} has an empty spot on their schedule."
      self.alert_url = "#{student_path(object_id)}" + "#tab_schedule"
      
    elsif type == "New Focus Needed"
      self.alert_text = "The term has begun and there are no Learning Objectives selected for focus in one of the student’s classes"
      self.is_notification = false
      self.is_email = true
      self.alert_url = "#"
      
    else
      #ERROR
    end

    self.save!

  end
end
