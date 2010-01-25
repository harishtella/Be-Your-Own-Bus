class ByobController < ApplicationController

  def index

    time_now = Time.zone.now.utc
    datetime_format = "%b %e @ %l:%M %p"

    @rides_driving = @current_user.rides_driving.find(:all, :order => 
        "start_datetime ASC", :conditions => 
        { :start_datetime_gte => time_now})
    @rides_riding = @current_user.rides_riding.find(:all, :order => 
        "start_datetime ASC", :conditions => 
        { :start_datetime_gte => time_now})
    @rides_watching = @current_user.rides_watching.find(:all, :order => 
        "start_datetime ASC", :conditions => 
        { :start_datetime_gte => time_now})

    @rides_driving.collect! do |ride| 
      current_ride = {} 
      current_ride[:ride_obj] = ride 
      current_ride[:date] = ride.start_datetime.strftime(datetime_format)
      current_ride
    end

    @rides_riding.collect! do |ride| 
      current_ride = {} 
      current_ride[:ride_obj] = ride 
      current_ride[:date] = ride.start_datetime.strftime(datetime_format)
      current_ride
    end

    @rides_watching.collect! do |ride| 
      current_ride = {} 
      current_ride[:ride_obj] = ride 
      current_ride[:date] = ride.start_datetime.strftime(datetime_format)
      current_ride
    end
  end
end

