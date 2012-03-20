class RegistrationConfirmation < ActionMailer::Base
  default from: "Conference Manager gk0r.go@gmail.com"
  
    def registration (user)
      @user = user

      mail  to: "gk0r.go@gmail.com", 
          subject: @user.first_name + " " + @user.last_name + 
                   " Registered with Conference Manager"
  end
end
