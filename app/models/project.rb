class Project < ApplicationModel
  # TODO: Numeric optional
  # attribute :id, Types::Coercible::String
  attribute :title, Types::Coercible::String
  attribute :description, Types::Coercible::String
end
