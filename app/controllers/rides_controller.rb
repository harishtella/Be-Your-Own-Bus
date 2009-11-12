require 'date' 

class RidesController < ApplicationController # GET /rides # GET /rides.xml
  def index
    @rides = Ride.all
    @rides_from_campus = Ride.find(:all, :conditions => { :tocampus => false})
    @rides_to_campus = Ride.find(:all, :conditions => { :tocampus => true})

    respond_to do |format|
      format.fbml 
    end
  end

  # GET /rides/1
  # GET /rides/1.xml
  def show
    @publish_ride_joined = session[:publish_ride_joined]
    @publish_ride_created = session[:publish_ride_created]
    session[:publish_ride_joined] = nil
    session[:publish_ride_created] = nil

    @ride = Ride.find(params[:id])

    datetime_format_string = "%l:%M %p on %A, %b %e, %Y"
    @ride_dropoff_datetime_formatted = @ride.dropoff_datetime.strftime(datetime_format_string)  
    @ride_pickup_datetime_formatted = @ride.pickup_datetime.strftime(datetime_format_string)
    
    @driver = @ride.driver.user 
    @driver_fb = Facebooker::User.new(@driver.facebook_id.to_s)
    @driver_info = {"name" => @driver_fb.name,
    "pic" => @driver_fb.pic_square,
    "profile_url" => @driver_fb.profile_url}

    @passengers_info = @ride.passengers.collect do |x| 
      @passenger = x.user
      @passenger_fb = Facebooker::User.new(@passenger.facebook_id.to_s) 
      {"name" => @passenger_fb.name,
        "pic" => @passenger_fb.pic_square,
        "profile_url" => @passenger_fb.profile_url}
    end

    respond_to do |format|
      format.fbml 
    end
  end

  # GET /rides/new
  # GET /rides/new.xml
  def new
    @ride = Ride.new

    respond_to do |format|
      format.fbml 
    end
  end

  # GET /rides/1/edit
  def edit
    @ride = Ride.find(params[:id])
  end

  # POST /rides
  # POST /rides.xml
  def create
    @ride = Ride.new(params[:ride])
    @ride.driver = @current_user.driver 

    @current_user_fb = facebook_session.user

    respond_to do |format|
      if @ride.save
        #RidePublisher.deliver_publish_stream(@current_user_fb,@current_user_fb,{:message => "foo"})
        session[:publish_ride_created] = true
        flash[:notice] = 'Ride was successfully created.'
        format.fbml { redirect_to(@ride) }
      else
        format.fbml { render :action => "new" }
      end
    end
  end

  def join 
    @ride = Ride.find(params[:id])
    @ride.passengers << @current_user.passenger

    respond_to do |format|
      if @ride.save
        session[:publish_ride_joined] = true
        format.fbml { redirect_to(@ride) }
      else
        format.fbml { redirect_to(@ride) }
      end
    end
  end

  # PUT /rides/1
  # PUT /rides/1.xml
  def update
    @ride = Ride.find(params[:id])

    respond_to do |format|
      if @ride.update_attributes(params[:ride])
        flash[:notice] = 'Ride was successfully updated.'
        format.fbml { redirect_to(@ride) }
      else
        format.fbml { render :action => "edit" }
      end
    end
  end

  # DELETE /rides/1
  # DELETE /rides/1.xml
  def destroy
    @ride = Ride.find(params[:id])
    @ride.destroy

    respond_to do |format|
      format.fbml { redirect_to(rides_url) }
    end
  end
end
