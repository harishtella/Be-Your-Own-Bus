class Driver < ActiveRecord::Base
  belongs_to :user
  has_many :rides
end
