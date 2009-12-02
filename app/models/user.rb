class User < ActiveRecord::Base
  has_one :driver 
  has_one :passenger
  has_many :comments

  def self.for(facebook_id)

    if User.exists?(:facebook_id => facebook_id) 
      return User.find_by_facebook_id(facebook_id)
    else
      new_user = User.new()
      new_user.facebook_id = facebook_id
      new_user.driver = Driver.create()
      new_user.passenger = Passenger.create()
      new_user.save()
      return new_user
    end

  end
end
