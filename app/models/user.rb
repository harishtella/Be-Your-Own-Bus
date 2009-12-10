class User < ActiveRecord::Base
  has_many :comments
  has_many :rides_driving, :class_name => "Ride" 
  has_many :riderships 
  has_many :rides_riding, :source => :ride, :through => :riderships 
  has_many :watcherships 
  has_many :rides_watched, :source => :ride, :through => :watcherships 

  def self.for(facebook_id)

    if User.exists?(:facebook_id => facebook_id) 
      return User.find_by_facebook_id(facebook_id)
    else
      new_user = User.new()
      new_user.facebook_id = facebook_id
      new_user.save()
      return new_user
    end

  end
end
