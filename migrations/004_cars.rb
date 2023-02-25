Sequel.migration do
  
  up do
    
    create_table(:cars) do
      primary_key :id, :type=>:Bignum
      foreign_key :user_id, :users, :null=>false, :type=>:Bignum
      String :marque, :null=>false
      String :modele, :null=>false
      String :prix, :null=>false
    end

  end

  down do
    drop_table(:cars)
  end

end