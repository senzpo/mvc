# frozen_string_literal: true

# Repository layer for User
class UserRepository < ApplicationRepository
  def self.all(params = {})
    ApplicationRepository::DB[:users].where(params).map { |p| User.new(p) }
  end

  def self.create(user_params)
    id = ApplicationRepository::DB[:users].insert(user_params)

    User.new(user_params.merge(id: id))
  end

  # def self.update(id, project_params)
  #   updated_count = ApplicationRepository::DB[:projects].where(id: id).update(project_params)
  #   raise NotFoundRecord if updated_count.zero?
  # end

  def self.delete(id)
    updated_count = ApplicationRepository::DB[:users].where(id: id).delete
  end
end
