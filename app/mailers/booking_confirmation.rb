class BookingConfirmation < ActionMailer::Base
  default from: "Conference Manager from@example.com"

  def booking (booking)
      @booking = booking

      mail  to: "gk0r.go@gmail.com", 
          subject: @booking.conference_number.conference_number + 
                   " Booked for " + @booking.date.strftime("%d/%m/%Y")
  end
end
