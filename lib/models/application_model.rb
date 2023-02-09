# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry.Types()
end

# Domain model
class ApplicationModel < Dry::Struct
end
