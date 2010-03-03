class CommentsController < ApplicationController 
  def create
    @ride = Ride.find(params[:ride_id])
    @comment = @ride.comment_on_ride(@current_user, params[:body])
    RideMailer.send_later(:deliver_comment_email, @ride, @comment)
    redirect_to @ride
  end
end

