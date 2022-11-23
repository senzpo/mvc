# frozen_string_literal: true

# Repository layer for User
class UserRepository < ApplicationRepository
  # def self.all
  #   ApplicationRepository::DB[:projects].all.map { |p| Project.new(p) }
  # end

  # def self.find(id)
  #   p = ApplicationRepository::DB[:projects].where(id: id).first
  #   raise NotFoundRecord if p.nil?

  #   Project.new(p)
  # end

  def self.create(user_params)
    id = ApplicationRepository::DB[:users].insert(user_params)

    User.new(user_params.merge(id: id))
  end

  # def self.update(id, project_params)
  #   updated_count = ApplicationRepository::DB[:projects].where(id: id).update(project_params)
  #   raise NotFoundRecord if updated_count.zero?
  # end

  # def self.delete(id)
  #   updated_count = ApplicationRepository::DB[:projects].where(id: id).delete
  #   raise NotFoundRecord if updated_count.zero?
  # end
end
