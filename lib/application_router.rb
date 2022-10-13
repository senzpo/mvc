class ApplicationRouter
  class Result
    attr_reader :controller, :action
    # controller 'api_v1_users' : nil
    # Api::V1::UsersController
    # action index/show/edit

    def initialize(route_spec, controller, action)
      @controller = controller
      @action = action
      @route_spec
    end
  end

  def initialize(&block)
    @routes = {}
    instance_eval(&block)
  end

  def get(route_spec, &block)
    result_string = block.call
    result_array = result_string.split("@")

    @routes["get@#{route_spec}"] = Result.new(result_array[0], result_array[1])
  end

  def post(route_spec, &block)
  end

  def resolve(path, method)
    # TODO: return ApplicationRouter::Result filled with controller, :action
    @routes["#{method}@#{path}"]
  end
end