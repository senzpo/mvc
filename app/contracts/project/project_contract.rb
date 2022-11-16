class ProjectContract < ApplicationContract
  params do
    required(:title).filled(:string)
    required(:description).maybe(:string)
  end

  rule(:title) do
    key.failure('must be greater than 3') if value.length < 3
  end
end
