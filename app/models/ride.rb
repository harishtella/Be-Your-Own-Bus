class Ride < ActiveRecord::Base
  has_and_belongs_to_many :passengers 
  belongs_to :driver 
end
