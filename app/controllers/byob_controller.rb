class ByobController < ApplicationController

  def index
    @rides_driving = @current_user.rides_driving
    @rides_riding = @current_user.rides_riding
    @rides_watching = @current_user.rides_watching

    datetime_format = "%b %e @ %l:%M %p"
 
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

