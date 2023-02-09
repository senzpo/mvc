# frozen_string_literal: true

# Repository layer for Project
class ProjectRepository < ApplicationRepository
  # Presenter for Project
  class ProjectRelation < ApplicationRelation
    wrap :project

    def author
      UserRepository.find(id: attributes[:user_id])
    end
  end

  def self.all(params = {})
    ApplicationRepository::DB[:projects].where(params).map { |p| ProjectRelation.new(p) }
  end

  def self.find(params)
    p = ApplicationRepository::DB[:projects].where(params).first
    raise NotFoundRecord if p.nil?

    ProjectRelation.new(p)
  end

  def self.create(project_params)
    id = ApplicationRepository::DB[:projects].insert(project_params)

    ProjectRelation.new(project_params.merge(id: id))
  end

  def self.update(id, project_params)
    updated_count = ApplicationRepository::DB[:projects].where(id: id).update(project_params)
    raise NotFoundRecord if updated_count.zero?
  end

  def self.delete(id)
    updated_count = ApplicationRepository::DB[:projects].where(id: id).delete
    raise NotFoundRecord if updated_count.zero?
  end
end
