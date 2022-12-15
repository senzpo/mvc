# frozen_string_literal: true

# Validation for deleting user in service model
class UserDeleteServiceContract < ApplicationContract
  params do
    required(:id).value(:integer)
  end
end
