class CommentsController < ApplicationController 
  def create
    comment_ride = Ride.find(params[:ride_id])
    comment_ride.comment_on_ride(@current_user, params[:body])
    redirect_to comment_ride
  end
end

