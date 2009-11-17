require 'date' 
require 'rubygems'
require 'activesupport'

class Time 
  def round (seconds = 60) 
    Time.at((self.to_f / seconds).round * seconds) 
  end
end

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

    @user_is_driver = (@driver.facebook_id == current_user.facebook_id)  
    @user_is_a_passenger = @ride.passengers.collect {|x|
    (x.user.facebook_id == current_user.facebook_id) }.inject{|a,b| a or b} 

    @passengers_info = @ride.passengers.collect do |x| 
      @passenger = x.user
      @passenger_fb = Facebooker::User.new(@passenger.facebook_id.to_s) 
      {"name" => @passenger_fb.name,
        "pic" => @passenger_fb.pic_square,
        "profile_url" => @passenger_fb.profile_url,
        "passenger_id" => x.id}
    end



    respond_to do |format|
      format.fbml 
    end
  end

  # GET /rides/new
  # GET /rides/new.xml
  def new
    @ride = Ride.new
    @ride.tocampus = false

    time_now = Time.now.round(5.minutes)
    @pickup_datetime_preset = split_up_datetime_for_calender_form(time_now) 
    @dropoff_datetime_preset = split_up_datetime_for_calender_form(time_now) 
   
    respond_to do |format|
      format.fbml 
    end
  end

  def split_up_datetime_for_calender_form(datetime)
    datetime_format_fulldate = "%Y-%m-%d %H:%M:%S"
    datetime_format_month = "%m"
    datetime_format_day = "%e"
    datetime_format_year = "%Y"
    datetime_format_hour = "%l"
    datetime_format_min = "%M"
    datetime_format_ampm = "%p"

    split_datetime = {}
    split_datetime[:fulldate] = datetime.strftime(datetime_format_fulldate)
    split_datetime[:month] =
    datetime.strftime(datetime_format_month).to_i
    split_datetime[:day] = datetime.strftime(datetime_format_day).to_i
    split_datetime[:year] = datetime.strftime(datetime_format_year).to_i
    split_datetime[:hour] = datetime.strftime(datetime_format_hour).to_i
    split_datetime[:min] = datetime.strftime(datetime_format_min).to_i
    split_datetime[:ampm] = datetime.strftime(datetime_format_ampm).downcase
    
    return split_datetime 
  end


  # GET /rides/1/edit
  def edit
    @ride = Ride.find(params[:id])
    @pickup_datetime_preset = split_up_datetime_for_calender_form(@ride.pickup_datetime)
    @dropoff_datetime_preset = split_up_datetime_for_calender_form(@ride.dropoff_datetime)

  end

  # POST /rides
  # POST /rides.xml
  def create

    ActionView::Base.field_error_proc = Proc.new do |html_tag, instance| 
      if (html_tag.slice(1,5) == "label")
        html_tag
      else 
        if instance.error_message.kind_of?(Array)  
          %(#{html_tag}&nbsp;<span class="validation-error">  
            #{instance.error_message.join(',')}</span>)  
        else  
          %(#{html_tag}&nbsp;<span class="validation-error">  
          #{instance.error_message}</span>)  
        end 
      end
    end 

    @ride = Ride.new(params[:ride])
    @ride.driver = @current_user.driver 
    @ride.seats_available = @ride.seats_total

    respond_to do |format|
      if @ride.save
        #RidePublisher.deliver_publish_stream(@current_user_fb,@current_user_fb,{:message => "foo"})
        session[:publish_ride_created] = true
        flash[:notice] = 'Ride was successfully created.'
        format.fbml { redirect_to(@ride) }
      else
        #error_string = ""
        #@ride.errors.each {|k,v| error_string += "#{k} #{v}<br/>" } 
        #flash[:error] = error_string

        @pickup_datetime_preset =
        split_up_datetime_for_calender_form(@ride.pickup_datetime) 
        @dropoff_datetime_preset =
        split_up_datetime_for_calender_form(@ride.dropoff_datetime) 
        @price_preset = if @ride.price then @ride.price.to_s else nil end 
        @seats_total_preset = if (@ride.seats_total and @ride.seats_total != 0) then @ride.seats_total.to_s else
        nil end 
        format.fbml { render :action => "new" }
      end
    end
  end

  def join 
    @ride = Ride.find(params[:id])
    if (@ride.seats_available > 0) 
      @ride.seats_available -= 1
      @ride.passengers << @current_user.passenger
      @ride.save
      session[:publish_ride_joined] = true
    else 
      flash[:error] = "Sorry, there are no seats left on this ride"
    end

    respond_to do |format|
        format.fbml { redirect_to(@ride) }
    end
  end

  def kick
    @ride = Ride.find(params[:id])
    @passenger = @ride.passengers.find(params[:passenger_id])
    @ride.passengers.delete(@passenger)
    @ride.seats_available += 1
    @ride.save

    respond_to do |format|
        format.fbml { redirect_to(@ride) }
    end
  end

  def leave
    @user_id = @current_user.facebook_id 
    @ride = Ride.find(params[:id])
    @passengers = @ride.passengers.select { |p| p.user.facebook_id == @user_id } 
    
    unless @passengers.empty?  
      @ride.passengers.delete(@passengers.pop)
      @ride.seats_available += 1
      @ride.save
    end

    respond_to do |format|
        format.fbml { redirect_to(@ride) }
    end
  end


  # PUT /rides/1
  # PUT /rides/1.xml
  def update
    @ride = Ride.find(params[:id])
    @ride.driver = @current_user.driver 


    respond_to do |format|
      if @ride.update_attributes(params[:ride])
        flash[:notice] = 'Ride was successfully updated.'
        format.fbml { redirect_to(@ride) }
      else
        @pickup_datetime_preset =
        split_up_datetime_for_calender_form(@ride.pickup_datetime) 
        @dropoff_datetime_preset =
        split_up_datetime_for_calender_form(@ride.dropoff_datetime) 
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
