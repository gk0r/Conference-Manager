class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authorize
  
  protected
  
  def authorize
     unless User.find_by_id(session[:user_id])       
       redirect_to login_path, notice: "Please Login"
     end
  end
  
  #   This is a "Global" method that returns the number of entries for the Pagination
  #   plugin. 
  def paginate_at ()
    return 9
  end
  
end
