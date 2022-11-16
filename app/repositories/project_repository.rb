class ProjectRepository < ApplicationRepository
  def self.all
    ApplicationRepository::DB[:projects].all.map { |p| Project.new(p) }
  end

  def self.create(project)
    hash_attributes = project.to_h
    ApplicationRepository::DB[:projects].insert(hash_attributes)
  end
end
