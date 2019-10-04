class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|

    	t.string	  :alert_type
    	    	
      t.integer   :object_entity_id
      t.string    :object_entity_type     	

      t.integer 	:target_entity_id
    	t.string	  :target_entity_type

      t.text      :alert_text
    	t.text		  :alert_url

      t.boolean   :is_notification,   default: true
      t.boolean   :is_email,        default: false
      t.boolean   :is_manual,       default: false

    	t.datetime	:deleted_at

      t.timestamps null: false
    end
  end
end
