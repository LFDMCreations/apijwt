class Car < Sequel::Model

  many_to_one :users

end