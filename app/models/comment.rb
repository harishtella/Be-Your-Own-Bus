class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :ride, :class_name=>"Ride"
end
