# frozen_string_literal: true

# Repository layer for Project
class ProjectRepository < ApplicationRepository
  def self.all
    ApplicationRepository::DB[:projects].all.map { |p| Project.new(p) }
  end

  def self.create(project)
    hash_attributes = project.to_h
    ApplicationRepository::DB[:projects].insert(hash_attributes)
  end

  def self.save(project)
    hash_attributes = project.to_h
    ApplicationRepository::DB[:projects].where(id: hash_attributes[:id]).update(hash_attributes)
  end

  def self.delete(id)
    ApplicationRepository::DB[:projects].where(id: id).delete
  end
end
