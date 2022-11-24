# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table(:users) do
      drop_column :name
      drop_column :password
      add_column :password_hash, String, null: false
      add_column :salt, String, null: false
    end
  end

  down do
    alter_table(:users) do
      drop_column :password_hash
      drop_column :salt
      add_column :password, String, null: false
      add_column :name, String, null: false
    end
  end
end
