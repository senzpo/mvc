# frozen_string_literal: true

# Repository layer for User
class UserRepository < ApplicationRepository
  def self.all(params = {}, includes: [])
    users = ApplicationRepository::DB[:users].where(params).to_a

    user_ids = users.map { |user| user[:id] }
    relations = {}
    relations[:projects] = ProjectRepository.all(user_id: user_ids) if includes.include?(:projects)

    users.map do |user|
      user.merge!(projects: relations[:projects].select { |p| p.user_id == user[:id] }) if includes.include?(:projects)
      User.new(user)
    end
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
    ApplicationRepository::DB[:users].where(id: id).delete
  end
end
