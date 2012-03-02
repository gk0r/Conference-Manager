class ConferenceNumbersController < ApplicationController
  # GET /conference_numbers
  def index
    @conference_numbers = ConferenceNumber.paginate page: params[:page], 
      order: 'conference_number asc',
      per_page: paginate_at()  
        
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /conference_numbers/1
  def show
    @conference_number = ConferenceNumber.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /conference_numbers/new
  def new
    @conference_number = ConferenceNumber.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /conference_numbers/1/edit
  def edit
    @conference_number = ConferenceNumber.find(params[:id])
  end

  # POST /conference_numbers
  def create
    @conference_number = ConferenceNumber.new(params[:conference_number])

    respond_to do |format|
      if @conference_number.save
        format.html { redirect_to conference_numbers_path, 
          notice: 'Conference number #{@conference_number.conference_number} was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /conference_numbers/1
  def update
    @conference_number = ConferenceNumber.find(params[:id])

    respond_to do |format|
      if @conference_number.update_attributes(params[:conference_number])
        format.html { redirect_to conference_numbers_path, 
          notice: "Conference number #{@conference_number.conference_number} was successfully updated." }        
      else
        format.html { render action: "edit" }
        
      end
    end
  end

  # DELETE /conference_numbers/1  
  def destroy
    @conference_number = ConferenceNumber.find(params[:id])
    @conference_number.destroy

    respond_to do |format|
      format.html { redirect_to conference_numbers_url }      
    end
  end
  
end
