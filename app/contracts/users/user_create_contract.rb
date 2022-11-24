# frozen_string_literal: true

# Validation for project model
class UserCreateContract < ApplicationContract
  params do
    required(:email).filled(:string)
    required(:password).filled(:string)
    required(:password_confirmation).filled(:string)
  end

  rule(:password, :password_confirmation) do
    key.failure('passwords must match') if values[:password] != values[:password_confirmation]
  end
end
