class BookingsController < ApplicationController
  # GET /bookings
  def index
    @bookings = Booking.where("date > ?", 
     Date.yesterday()).paginate page: params[:page], 
      order: 'created_at asc',
      per_page: 15
        
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
  end

  # POST /bookings
  def create
    @booking = Booking.new(params[:booking])
    @booking.user_id = session[:user_id]
    
    @conference_numbers = ConferenceNumber.find_by_sql(["SELECT id, conference_number FROM conference_numbers WHERE id NOT IN (SELECT conference_numbers.id FROM conference_numbers INNER JOIN bookings ON conference_numbers.id=bookings.conference_number_id WHERE bookings.date == ? AND (bookings.time_start BETWEEN ? AND ?) OR (bookings.time_finish BETWEEN ? AND ?))", @booking.date, @booking.time_start, @booking.time_finish, @booking.time_start, @booking.time_finish])
  
    respond_to do |format|
      if @booking.conference_number_id == nil
        @ready_to_book = true
        format.html { render action: "new" }
      else 
      
        if @booking.save
          format.html { redirect_to @booking, notice: 'Booking was successfully created.' }
          format.js        
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
  def check_availability
    @booking = Booking.new
    
    @booking.conference_number_id = params[:conference_number_id]
    @booking.user_id              = params[:user_id]
    @booking.date                 = params[:date]
    @booking.time_start           = params[:time_start]
    @booking.time_finish          = params[:time_finish]
        
    if @booking.user_id and @booking.date and @booking.time_start and @booking.time_finish 
      redirect_to :action       => "book", 
                  :user_id      => params[:user_id], 
                  :date         => params[:date], 
                  :time_start   => params[:time_start], 
                  :time_finish  => params[:time_finish]
    else
      respond_to do |format|
        format.html { render action: "check_availability" }
      end
    end    
  end
  
  def book
    @booking = Booking.new
    
    @booking.conference_number_id = params[:conference_number_id]
    @booking.user_id              = params[:user_id]
    @booking.date                 = params[:date]
    @booking.time_start           = params[:time_start]
    @booking.time_finish          = params[:time_finish]
    
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
    
    respond_to do |format|
      format.html { render action: "book" }
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
  
end
