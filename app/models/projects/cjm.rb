# frozen_string_literal: true

module Projects
  class CJM < ApplicationModel
    attribute? :id, Types::Coercible::Integer.optional.meta(info: 'Uniq ID')
    attribute :title, Types::Coercible::String.constrained(min_size: 3)
    attribute :scenario, Types::Coercible::String
    attribute :opportunities, Types::Coercible::String
    attribute :expectations, Types::Coercible::String
    attribute? :notes, Types::Coercible::String.optional
  end
end
