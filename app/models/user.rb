class User < ActiveRecord::Base
  # Foreign Key relationshipo
  has_many  :booking,         :dependent => :destroy   
  
  # Validation
  validates :logon,           :presence   => true,
                              :length     => {:minimum => 3, :maximum => 6},
                              :uniqueness => true
                              
  validates :first_name,      :presence => true
  
  validates :last_name,       :presence => true
  
  validates :spectrum_number, :presence => true,
                              :length   => {:minimum => 6, :maximum => 10}
                              
  # Do not require the user to have a password
  
  validates :admin,           :inclusion => { :in => [true, false] } 
end
