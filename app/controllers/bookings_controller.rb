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

  # GET /bookings/new
  def new
    @booking = Booking.new    

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /bookings/1/edit
  def edit
    @booking = Booking.find(params[:id])        
    get_available_conference_numbers()
  end

  # POST /bookings
  def create  
    @booking = Booking.new(params[:booking])    
    
    # Populate the object
    @booking.user_id = session[:user_id] # This is to prevent the object from saving
    @booking.date = Date.parse(params[:date])
    @booking.time_start = Time.parse("#{@booking.date} #{Time.parse(params[:time_start])}")
    @booking.time_finish = Time.parse("#{@booking.date} #{Time.parse(params[:time_finish])}")
        
    get_available_conference_numbers()
  
    respond_to do |format|
      if @booking.conference_number_id == nil
        @ready_to_book = true
        format.html { render action: "new" }
      else 
      
        if @booking.save          
          format.html { redirect_to @booking, notice: 'Booking was successfully created.' }
          format.js
          BookingConfirmation.booking(@booking).deliver        
        else
          @ready_to_book = true # This will allow me to separate the 'first' and the 'second' pass
          format.html { render action: "new" }
          format.js
        end
      end
        
    end
  end

  # PUT /bookings/1
  def update
    @booking = Booking.find(params[:id])

    respond_to do |format|
      if @booking.update_attributes(params[:booking])
        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
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
    
    # respond_to do |format|
     # format.html { render action: "book" }
    # end
    
    #--------------------
    
    respond_to do |format|
      if @booking.save          
        format.html { redirect_to bookings_url, notice: 'Booking was successfully created.' }
        # format.js
        # BookingConfirmation.booking(@booking).deliver
      elsif @conference_numbers # Redirect back to BOOK_URL if no Conference Numbers are available at the specified time.
        format.html { redirect_to book_url, 
          notice: 'Sorry, no Conference Numbers are available at the time you have chosen. Please choose another time.'}
      else          
        format.html { render action: "book" }
        # format.js
      end
    end
    
  end
  
  def test1
    @booking = Booking.find("1")
 
    respond_to do |format|
      format.html { render action: "test1" }
      format.js      
    end
  end
  
  def test2
    respond_to do |format|
      format.html { render action: "test2" }
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
            WHERE bookings.date == ? 
            AND (bookings.time_start BETWEEN ? AND ?) 
            OR (bookings.time_finish BETWEEN ? AND ?)
          )", 
      @booking.date, 
      @booking.time_start, 
      @booking.time_finish, 
      @booking.time_start, 
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