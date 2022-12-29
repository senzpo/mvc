# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:steps) do
      primary_key :id
      String :title, null: false
      String :description, null: true
      Integer :scholarship, null: false

      foreign_key :cjm_id, :cjms
    end
  end

  down do
    drop_table(:steps)
  end
end
