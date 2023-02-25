Sequel.migration do
  
  up do
    
    create_table(:users) do
      primary_key :id, :type=>:Bignum
      String :name, size: 250, null: false
    end

  end

  down do
    drop_table(:users)
  end

end