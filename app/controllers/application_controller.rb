class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authorize
  
  protected
  
  def authorize
     unless User.find_by_id(session[:user_id])       
       redirect_to login_path, notice: "Please Login"
     end
  end
  
end
