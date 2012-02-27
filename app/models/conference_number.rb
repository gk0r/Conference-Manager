class ConferenceNumber < ActiveRecord::Base
  
  has_many :booking, :dependent => :destroy
  
  validates :conference_number, :presence   => true,
                                :length     => {:minimum => 6, :maximum => 10},
                                :uniqueness => true
  
  # # CONF_NUMBERS = [ "55 1111", "55 2222", "55 3333" ]                              
  # CONF_NUMBERS
  # conference_number = ConferenceNumber.all
#   
  # for conference_number.each do |number|
    # CONF_NUMBERS.concat(number.conference_number)
  # end
  
                            
end
