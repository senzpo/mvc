# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table(:projects) do
      add_foreign_key :user_id, :users
    end
  end

  down do
    alter_table(:projects) do
      drop_foreign_key :user_id
    end
  end
end
