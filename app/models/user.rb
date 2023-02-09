# frozen_string_literal: true

class User < ApplicationModel
  attribute? :id, Types::Coercible::Integer.optional.meta(info: 'Uniq ID')
  attribute :email, Types::Coercible::String
  attribute :password_hash, Types::Coercible::String
  attribute :salt, Types::Coercible::String
end
