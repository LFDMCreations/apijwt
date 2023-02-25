class User < Sequel::Model

  one_to_many :user_passwords
  one_to_many :cars
 # one_to_one :userJwtRefresh

end




class UserPassword < Sequel::Model

  many_to_one :users

end