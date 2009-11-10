class UsersController < ApplicationController

  def login
    @user = User.find(params[:id])  
    session[:userInfo] = @user

    respond_to do |format| 
      format.fbml { redirect_to :controller => 'byob' }
    end
  end


  
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.fbml
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.fbml # show.html.erb
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.fbml
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    
    @user.driver = Driver.create()
    @user.passenger = Passenger.create()

    respond_to do |format|
      if @user.save
        flash[:notice] = "Thanks for signing up #{@user.name}."
        session[:curUser] = @user
        format.fbml { redirect_to :controller => 'byob' }
      else
        format.fbml { render :action => "new" }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Your info has been updated.'
        format.fbml { redirect_to(@user) }
      else
        format.fbml { render :action => "edit" }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.fbml { redirect_to(users_url) }
    end
  end
end
