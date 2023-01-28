# frozen_string_literal: true

# Repository layer for Project
class ProjectRepository < ApplicationRepository
  class ProjectPresenter
    def initialize(project)

    end

    def user

    end
  end

  def self.all(params = {}, includes: [])
    includes[:user]

    ApplicationRepository::DB[:projects].where(params).map { |p| ProjectPresenter.new(p) }
  end

  def self.find(params)
    p = ApplicationRepository::DB[:projects].where(params).first
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
