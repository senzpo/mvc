# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:projects) do
      primary_key :id
      String :title, null: false
      String :description, null: true
    end
  end

  down do
    drop_table(:projects)
  end
end
