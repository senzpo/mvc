# frozen_string_literal: true

# Repository layer for Project
class ProjectRepository < ApplicationRepository
  def self.all(params = {})
    ApplicationRepository::DB[:projects].where(params).map { |p| Project.new(p) }
  end

  def self.find(id)
    p = ApplicationRepository::DB[:projects].where(id: id).first
    raise NotFoundRecord if p.nil?

    Project.new(p)
  end

  def self.create(project_params)
    id = ApplicationRepository::DB[:projects].insert(project_params)

    Project.new(project_params.merge(id: id))
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
