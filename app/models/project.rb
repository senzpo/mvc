# frozen_string_literal: true

class Project < ApplicationModel
  attribute :id, Types::Coercible::Integer.optional.meta(info: 'Uniq ID')
  attribute :title, Types::Coercible::String.constrained(min_size: 3)
  attribute :description, Types::Coercible::String.optional
end
