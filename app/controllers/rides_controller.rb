require 'date' 
require 'rubygems'
require 'active_support'
require 'ar-extensions'
include ActionView::Helpers::UrlHelper 
include ActionView::Helpers::TagHelper
include Facebooker::Rails::Helpers


class RidesController < ApplicationController 
  def index
    @view_past_rides = params[:view_past_rides]
    time_now = Time.zone.now.utc

    if @view_past_rides
      @rides_from_campus = Ride.find(:all, :order => 
      "start_datetime ASC", :conditions => 
      { :tocampus => false, :start_datetime_lt => time_now })
      @rides_to_campus = Ride.find(:all, :order => 
      "start_datetime ASC", :conditions => 
      { :tocampus => true, :start_datetime_lt => time_now })
    else 
      @rides_from_campus = Ride.find(:all, :order => 
      "start_datetime ASC", :conditions => 
      { :tocampus => false, :start_datetime_gte => time_now})
      @rides_to_campus = Ride.find(:all, :order => 
      "start_datetime ASC", :conditions => 
      { :tocampus => true, :start_datetime_gte => time_now})
    end

    @rides_from_campus_with_dates = []
    @rides_to_campus_with_dates = []
    index_format = "%b %e @ %l:%M %p"
  
    @rides_from_campus.each do |ride| 
      current_ride = {} 
      current_ride[:ride_obj] = ride 
      current_ride[:date] = ride.start_datetime.strftime(index_format)
      @rides_from_campus_with_dates << current_ride
    end

    @rides_to_campus.each do |ride| 
      current_ride = {} 
      current_ride[:ride_obj] = ride 
      current_ride[:date] = ride.start_datetime.strftime(index_format)
      @rides_to_campus_with_dates << current_ride
    end

    respond_to do |format|
      format.fbml 
    end
  end

  def show
    @publish_ride_joined = session[:publish_ride_joined]
    @publish_ride_created = session[:publish_ride_created]
    session[:publish_ride_joined] = nil
    session[:publish_ride_created] = nil
    
    @ride = Ride.find(params[:id])
    @comments = @ride.comments
    @comments.sort! {|x,y| -1 * (x.created_at <=> y.created_at) }

    datetime_format_string = "%l:%M %p on %A, %b %e, %Y"
    @ride_start_datetime_formatted = @ride.start_datetime.strftime(datetime_format_string)

    @user_is_driver = (@ride.driver == @current_user)  
    @user_is_a_passenger = @ride.riders.collect {|x|
    x == @current_user }.inject{|a,b| a or b} 
    @user_is_a_watcher = @ride.watchers.collect {|x|
    x == @current_user }.inject{|a,b| a or b} 

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

  def new
    @ride = Ride.new
    @return_ride = Ride.new

    #round time to nearest minute divisible by 5
    time_now = Time.zone.at((Time.zone.now.to_f / 5.minutes).round * 5.minutes)

    @start_datetime_preset = split_up_datetime_for_calender_form(time_now) 
    @return_datetime_preset = split_up_datetime_for_calender_form(time_now) 
    @return_ride_desired = false
   
    respond_to do |format|
      format.fbml 
    end
  end

  def edit
    @ride = Ride.find(params[:id])
    @start_datetime_preset = split_up_datetime_for_calender_form(@ride.start_datetime)
  end

  def create
    @ride = Ride.new(params[:ride])
    @ride.driver = @current_user

    @return_ride = Ride.new()    
    @ride.return_ride = @return_ride
    @return_ride.origin_ride = @ride

    @return_ride_desired = params[:return_ride_desired].to_i.nonzero?

    if @return_ride_desired
      @return_ride.name = @ride.name + " (return ride)" 
      @return_ride.driver = @ride.driver
      @return_ride.price = @ride.price
      @return_ride.seats_total = @ride.seats_total
      @return_ride.tocampus = (not @ride.tocampus)
      @return_ride.place = @ride.place
      @return_ride.start_datetime = params[:return_ride][:start_datetime]
      @return_ride.about = @ride.about
    else 
      @ride.return_ride = nil
    end

    respond_to do |format|
      if @ride.save
        #RidePublisher.deliver_publish_stream(@current_user_fb,@current_user_fb,{:message => "foo"})
        session[:publish_ride_created] = true
        flash[:notice] = 'Ride was successfully created.'
        format.fbml { redirect_to(@ride) }
      else
        @start_datetime_preset =
        split_up_datetime_for_calender_form(@ride.start_datetime) 
        if @return_ride_desired
          @return_datetime_preset =
          split_up_datetime_for_calender_form(@return_ride.start_datetime) 
        else
          @return_datetime_preset = @start_datetime_preset
        end
        @price_preset = @ride.price.to_s  
        @seats_total_preset = @ride.seats_total.to_s 
        format.fbml { render :action => "new" }
      end
    end
  end

  def update
    @ride = Ride.find(params[:id])

    respond_to do |format|
      if @ride.update_attributes(params[:ride])
        flash[:notice] = 'Ride was successfully updated.'
        format.fbml { redirect_to(@ride) }
      else
        @start_datetime_preset =
        split_up_datetime_for_calender_form(@ride.start_datetime) 
        format.fbml { render :action => "edit" }
      end
    end
  end

  def destroy
    @ride = Ride.find(params[:id])
    @ride.destroy

    respond_to do |format|
      format.fbml { redirect_to(rides_url) }
    end
  end

  def get_ride_people_excluding(ride, excluded_user)
    ride_people = [] 
    unless ride.driver == excluded_user 
      ride_people << ride.driver
    end

    ride.riders.each do |r| 
      unless r == excluded_user
        ride_people << r 
      end
    end

    return ride_people
  end

  def join 
    @ride = Ride.find(params[:id], :include => [:driver, :riders, :watchers])

    seats_available = (@ride.seats_total - @ride.seats_filled) > 0

    if (seats_available) 
      @ride.seats_filled += 1
      @ride.riders << @current_user
      if @ride.watchers.exists?(@current_user)
        @ride.watchers.delete(@current_user)
      end
      @ride.save
      session[:publish_ride_joined] = true
      flash[:notice] = "You have joined this ride." 
   
      notification_message = ""
      notification_message += fb_name(@current_user)  
      notification_message += " joined "
      notification_message += fb_name(@ride.driver,{:possessive => true})
      notification_message += " ride, " 
      notification_message += link_to(@ride.name, @ride) + "."

      notification_recipients = get_ride_people_excluding(@ride, @current_user)
      unless notification_recipients.empty?
        RidePublisher.deliver_ride_notification(notification_recipients, 
        notification_message)
      end
    else 
      flash[:error] = "Sorry, there are no seats left on this ride."
    end

    respond_to do |format|
        format.fbml { redirect_to(@ride) }
    end
  end

  def kick
    @ride = Ride.find(params[:id], :include => [:driver, :riders, :watchers])
    @rider = @ride.riders.find(params[:rider_id])

    @ride.riders.delete(@rider)
    @ride.seats_filled -= 1
    @ride.save
    flash[:notice] = "You have kicked a rider off this ride." 

    notification_message = ""
    notification_message += fb_name(@current_user)  
    notification_message += " kicked "
    notification_message += fb_name(@rider)
    notification_message += " off " + fb_pronoun(@current_user,{:possessive =>
    true}) + " ride, "
    notification_message += link_to(@ride.name, @ride) + "."

    notification_recipients = get_ride_people_excluding(@ride, @current_user)
    unless notification_recipients.empty? 
      RidePublisher.deliver_ride_notification(notification_recipients,
      notification_message)
    end

    respond_to do |format|
        format.fbml { redirect_to(@ride) }
    end
  end
 
  def leave
    @ride = Ride.find(params[:id], :include => [:driver, :riders, :watchers])
    
    unless @ride.nil?  
      @ride.riders.delete(@current_user)
      @ride.seats_filled -= 1
      @ride.save
      flash[:notice] = "You have left this ride." 

      notification_message = ""
      notification_message += fb_name(@current_user)  
      notification_message += " left the ride, "
      notification_message += link_to(@ride.name, @ride) + "."

      notification_recipients = get_ride_people_excluding(@ride, @current_user)
      unless notification_recipients.empty?
        RidePublisher.deliver_ride_notification(notification_recipients,
        notification_message)
      end
    end

    respond_to do |format|
        format.fbml { redirect_to(@ride) }
    end
  end

  def watch
    @ride = Ride.find(params[:id])
    @ride.watchers << @current_user
    @ride.save
    flash[:notice] = "You are now watching this ride." 
   
    respond_to do |format|
        format.fbml { redirect_to(@ride) }
    end
  end

  def unwatch
    @ride = Ride.find(params[:id])
    @ride.watchers.delete(@current_user)
    @ride.save
    flash[:notice] = "You have stopped watching this ride." 

    respond_to do |format|
        format.fbml { redirect_to(@ride) }
    end
  end
end
