# frozen_string_literal: true

# Validation for user model created from API
class UserCreateApiContract < ApplicationContract
  params do
    required(:email).filled(:string)
    required(:password).filled(:string)
  end
end
