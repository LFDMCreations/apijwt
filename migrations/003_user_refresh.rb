Sequel.migration do
  
  up do
    
    create_table(:user_jwt_refresh_keys) do
      primary_key :id, :type=>:Bignum
      foreign_key :user_id, :users, :null=>false, :type=>:Bignum, :unique=>true
      String :token, :null=>false
    end

  end

  down do
    drop_table(:user_jwt_refresh_keys)
  end

end