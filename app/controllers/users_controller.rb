class UsersController < ApplicationController
  skip_before_filter :authorize, only: [:new, :create]
  
  # GET /users
  def index
     @users = User.paginate page: params[:page], 
      order: 'first_name asc',
      per_page: paginate_at()       

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /users/new
  def new    
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /users/1/edit
  def edit
  
    if User.find(session[:user_id]).admin
      @user = User.find(params[:id])
    else
      @user = User.find(session[:user_id])
    end
        
  end

  # POST /users
  def create
    @user = User.new(params[:user])
    @user[:admin] = false

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'Registration successful.' }
        # This is for a new User who has not registered before, and does not have
        # a current session. Users who have already authenticated will not be automatically
        # logged in as the newly created user.
        if session[:user_id] == nil
          session[:user_id] = @user.id
        end
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  def update   
  
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    if User.find(session[:user_id]).admin
      @user.destroy
    end

    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end
end
