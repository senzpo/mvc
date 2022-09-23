class ApplicationRouter
  class Result
    attr_reader :controller, :action
    # controller 'api_v1_users' : nil
    # Api::V1::UsersController
    # action index/show/edit
  end

  def initialize

  end

  def resolve(path, method)
    # TODO: return ApplicationRouter::Result filled with controller, :action
  end
end