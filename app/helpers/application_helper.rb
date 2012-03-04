module ApplicationHelper
  
  def add_button (label, image, button_class)     
    @label = label
    @image = image
    @class = button_class
    
    render :file  => "./layouts/buttons"
  end  
  
  def add_link (label, image, link_class, path)
    @label = label
    @image = image
    @class = link_class
    @path  = path
    
    render :file  => "./layouts/links"
  end
  
end

