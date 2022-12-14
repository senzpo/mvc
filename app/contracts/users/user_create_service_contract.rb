# frozen_string_literal: true

# Validation for user in service model
class UserCreateServiceContract < ApplicationContract
  params do
    required(:email).filled(:string)
    required(:password).filled(:string)
  end
end
