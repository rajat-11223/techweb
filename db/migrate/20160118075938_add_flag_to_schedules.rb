class AddFlagToSchedules < ActiveRecord::Migration
  def change
  		add_column :terms,:clone_flag,:boolean, 	default: false
  end
end
