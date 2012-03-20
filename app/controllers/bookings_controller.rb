class BookingsController < ApplicationController
  # GET /bookings
  def index
       
    @bookings = Booking.where("date > ?", 
     Date.yesterday()).paginate page: params[:page], 
      order: 'created_at asc',
      per_page: paginate_at()
        
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /bookings/1
  def show
    @booking = Booking.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # DELETE /bookings/1
  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to bookings_url }
    end
  end
  
  # This action will check availability of a conference number for a particular time.   
  def check
    @booking = Booking.new
    
    parse_booking()    
       
    if @booking.user_id and @booking.date and @booking.time_start and @booking.time_finish 
      book(@booking)
    else
      respond_to do |format|
        format.html { render action: "check" }
      end
    end    
  end
  
  def book (booking)
    @booking = booking    
  
    get_available_conference_numbers
    
    respond_to do |format|
      if @booking.save          
        format.html { redirect_to bookings_url, notice: 'Booking was successfully created.' }
        
        BookingConfirmation.booking(@booking).deliver
      elsif !@conference_numbers # Redirect back to BOOK_URL if no Conference Numbers are available at the specified time.
        format.html { redirect_to book_url, 
          notice: 'Sorry, no Conference Numbers are available at the time you have chosen. Please choose another time.'}
      else          
        format.html { render action: "book" }
      end
    end
    
  end
 
  # This helper method retrieves available conference numbers
  def get_available_conference_numbers()
    @conference_numbers = ConferenceNumber.find_by_sql(
      ["SELECT id, conference_number 
        FROM conference_numbers 
        WHERE id NOT IN 
          (SELECT conference_numbers.id 
            FROM conference_numbers 
            INNER JOIN bookings 
            ON conference_numbers.id=bookings.conference_number_id 
            WHERE (bookings.time_start BETWEEN ? AND ?) 
            OR (bookings.time_finish BETWEEN ? AND ?)
          )",       
      @booking.time_start , 
      @booking.time_finish - 1.second, 
      @booking.time_start + 1.second, 
      @booking.time_finish])
  end
  
  # This helper method parses the Booking Object from the various forms.
  def parse_booking ()
      @booking.user_id = session[:user_id] 
      
      begin 
        @booking.date = Date.parse(params[:date])
      rescue
        @booking.date = nil
      end
      
      begin 
        @booking.time_start = Time.parse("#{@booking.date} #{Time.parse(params[:time_start])}")
      rescue
        @booking.time_start = nil
      end
          
      begin 
        @booking.time_finish = Time.parse("#{@booking.date} #{Time.parse(params[:time_finish])}")
      rescue
        @booking.time_finish = nil
      end
      
      begin 
        @booking.conference_number_id = params[:conference_number_id]
      rescue
        @booking.conference_number_id = nil
      end  
  end
  
end