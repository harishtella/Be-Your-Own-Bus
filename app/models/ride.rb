class Ride < ActiveRecord::Base
  has_many :comments, :class_name=>"Comment", :foreign_key=>:ride_id
  belongs_to :driver, :class_name => "User"
  has_many :riderships 
  has_many :riders, :source => :user, :through => :riderships 
  has_many :watcherships 
  has_many :watchers, :source => :user, :through => :watcherships 

  validates_presence_of :name
  validates_presence_of :pickup
  validates_presence_of :dropoff
  validates_presence_of :pickup_datetime
  validates_presence_of :dropoff_datetime
    
  validates_length_of :name, :maximum=>30
  validates_length_of :pickup, :maximum=>30
  validates_length_of :dropoff, :maximum=>30

  validates_numericality_of :price, :greater_than_or_equal_to => 0,
  :message => "include a valid price"

  validates_numericality_of :seats_total, :only_integer => true,
  :greater_than_or_equal_to => 1, :message => 
  "must have at least one passenger"

  validate :pickup_datetime_cant_be_in_the_past
  validate :dropoff_datetime_cant_be_in_the_past
  validate :pickup_datetime_comes_before_dropoff_datetime
  validate :seats_total_gte_seats_taken 

  def comment_on_ride(user, body)
    comments.create!(:user=>user, :body=>body)
  end

  def seats_total_gte_seats_taken 
    errors.add(:seats_total,
    "can't be less than the current number of passengers") if 
    seats_total < seats_filled 
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
