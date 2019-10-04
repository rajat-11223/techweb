class ErrorsController < ApplicationController
  skip_before_filter :authenticate_user!
  def not_found
    render :status => 404, :formats => [:html]
  end
 
  def unacceptable
    render :status => 422, :formats => [:html]
  end
 
  def internal_error
    render :status => 500, :formats => [:html]
  end
end