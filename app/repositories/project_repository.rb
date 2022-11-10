class ProjectRepository < ApplicationRepository
  def self.all
    # TODO: should return Project instead of hash
    ApplicationRepository::DB[:projects].all
  end

  def self.create(project_params)
    # TODO: should save Project instead of hash params
    ApplicationRepository::DB[:projects].insert(project_params)
  end
end
