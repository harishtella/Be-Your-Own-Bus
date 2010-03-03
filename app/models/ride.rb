class Ride < ActiveRecord::Base
  has_many :comments, :class_name=>"Comment", :foreign_key=>:ride_id
  belongs_to :driver, :class_name => "User"
  has_many :riderships 
  has_many :riders, :source => :user, :through => :riderships 
  has_many :watcherships 
  has_many :watchers, :source => :user, :through => :watcherships 
  belongs_to :origin_ride, :class_name => "Ride"
  has_one :return_ride, :class_name => "Ride", :foreign_key => 
  :origin_ride_id
  
  validates_presence_of :name
  validates_presence_of :place
  validates_presence_of :start_datetime
  validates_associated :return_ride 
  
  validates_length_of :name, :maximum=>30, :unless=> "origin_ride" 
  validates_length_of :place, :maximum=>30

  validates_numericality_of :price, :greater_than_or_equal_to => 0,
  :message => "include a valid price"

  validates_numericality_of :seats_total, :only_integer => true,
  :greater_than_or_equal_to => 1, :message => 
  "must have at least one passenger"

  validate :start_datetime_cant_be_in_the_past
  validate :seats_total_gte_seats_taken 
  validate :start_datetime_comes_before_return_datetime, 
  :unless => "return_ride.nil?"
  validate :start_datetime_comes_after_origin_datetime,
  :unless => "origin_ride.nil?"


  def comment_on_ride(user, body)
    comment = comments.create!(:user=>user, :body=>body)
    return comment
  end

  def return_ride?
    return_ride == true
  end

  def seats_total_gte_seats_taken 
    errors.add(:seats_total,
    "can't be less than the current number of passengers") if 
    seats_total < seats_filled 
  end

  def start_datetime_cant_be_in_the_past
    errors.add(:start_datetime, 
    "can't be in the past unless you have a time machine") if 
    start_datetime.to_datetime < Time.zone.now
  end
  
  def start_datetime_comes_before_return_datetime
    errors.add(:start_datetime, 
    "can't be after return ride's starting time") if 
    start_datetime.to_datetime > return_ride.start_datetime.to_datetime
  end

  def start_datetime_comes_after_origin_datetime
    errors.add(:start_datetime, 
    "can't be before origin ride's starting time") if 
    start_datetime.to_datetime < origin_ride.start_datetime.to_datetime
  end

end
