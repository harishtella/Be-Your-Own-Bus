class Ride < ActiveRecord::Base
  has_and_belongs_to_many :passengers 
  belongs_to :driver 
  has_many :comments, :class_name=>"Comment", :foreign_key=>:ride_id

  validates_presence_of :name
  validates_presence_of :pickup
  validates_presence_of :dropoff
  validates_presence_of :pickup_datetime
  validates_presence_of :dropoff_datetime

  validates_numericality_of :price, :greater_than_or_equal_to => 0 
  validates_numericality_of :seats_total, :only_integer => true,
  :greater_than_or_equal_to => 1

  validate :pickup_datetime_cant_be_in_the_past, :on => :create
  validate :dropoff_datetime_cant_be_in_the_past, :on => :create
  validate :pickup_datetime_comes_before_dropoff_datetime, :on => :create

  def comment_on_ride(user, body)
    comments.create!(:user=>user, :body=>body)
  end


  def pickup_datetime_cant_be_in_the_past
    errors.add(:pickup_datetime, 
    "can't be in the past unless you have a time machine") if 
    pickup_datetime.to_datetime < Time.zone.now
  end
  def dropoff_datetime_cant_be_in_the_past
    errors.add(:dropoff_datetime, 
    "can't be in the past unless you have a time machine") if 
    dropoff_datetime.to_datetime < Time.zone.now 
  end
  def pickup_datetime_comes_before_dropoff_datetime
    if pickup_datetime > dropoff_datetime 
      errors.add(:pickup_datetime, "can't be after ending date/time")   
      errors.add(:dropoff_datetime, "can't be before starting date/time")
    end
  end

end
