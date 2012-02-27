class Booking < ActiveRecord::Base
  belongs_to :user
  belongs_to :conference_number
  
  validates :conference_number_id,  :presence   => true
  validates :user_id,               :presence   => true
  validates :date,                  :presence   => true
  validates :time_start,            :presence   => true
  validates :time_finish,           :presence   => true
                             
  
end
