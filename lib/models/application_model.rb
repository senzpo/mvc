# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry.Types()
end

# Domain model
class ApplicationModel < Dry::Struct
  def self.has_many(relation, class_name:)
    attribute? relation, Dry::Types['array'].optional.meta(info: "Has many #{class_name}")
  end

  def self.belongs_to(relation, class_name:)
    attribute "#{relation}_id".to_sym, Types::Coercible::Integer.meta(info: "#{class_name} ID")
    attribute? relation
  end
end
