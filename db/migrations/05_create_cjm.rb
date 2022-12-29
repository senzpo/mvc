# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:cjms) do
      primary_key :id
      String :title, null: false
      String :scenario, null: false
      String :opportunities, null: false
      String :expectations, null: false
      String :notes, null: true

      foreign_key :project_id, :projects
    end
  end

  down do
    drop_table(:cjms)
  end
end
