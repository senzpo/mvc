# frozen_string_literal: true

# Validation for project model
class ProjectContract < ApplicationContract
  params do
    required(:title).filled(:string)
    required(:description).maybe(:string)
    required(:user_id).filled(:integer)
  end

  rule(:title) do
    key.failure('must be greater than 3') if value.length < 3
  end
end
