Sequel.migration do
  
  up do
    
    create_table(:user_passwords) do
      primary_key :id, :type=>:Bignum
      foreign_key :user_id, :users, :null=>false, :type=>:Bignum, :unique=>true
      String :passe, size: 250, null: false
    end

  end

  down do
    drop_table(:user_passwords)
  end

end