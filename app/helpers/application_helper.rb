module ApplicationHelper
  
  def add_button (label, image, button_class)     
    @label = label
    @image = image
    @class = button_class
    
    render :file  => "./layouts/buttons"
  end  
  
end

