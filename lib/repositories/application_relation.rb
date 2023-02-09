# frozen_string_literal: true

# Base relation object
class ApplicationRelation
  def self.wrap(klass)
    define_method :wrapped_class do
      instance_eval klass.to_s.capitalize, __FILE__, __LINE__ # Return wrapped class
    end
  end

  attr_reader :target, :attributes

  def initialize(attributes)
    raise 'Please define wrapped class with wrap class method' unless respond_to?(:wrapped_class)

    @target = wrapped_class.new(attributes)
    @attributes = attributes
  end

  def method_missing(method)
    target.send(method)
  end

  def respond_to?(method)
    methods.include?(method) || target.respond_to?(method)
  end

  def respond_to_missing?(method)
    target.respond_to_missing?(method)
  end

  def class
    target.class
  end
end
