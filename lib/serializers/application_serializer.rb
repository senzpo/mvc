# frozen_string_literal: true

# All app serializers must be subclasses of ApplicationSerializer
class ApplicationSerializer
  attr_reader :entity

  def self.attributes(*args)
    define_method :attributes do
      args
    end
  end

  def self.type(entity_type)
    define_method :type do
      entity_type
    end
  end

  def initialize(entity)
    @entity = entity
  end

  def to_h
    result_attributes = {}
    attributes.each do |attr|
      result_attributes[attr] = get_attribute(attr)
    end
    { data: { type: type, id: id, attributes: result_attributes } }
  end

  def get_attribute(attr)
    if respond_to?(attr)
      send(attr)
    elsif entity.respond_to?(attr)
      entity.send(attr)
    else
      raise NoMethodError, "Undefined serialize key #{attr}"
    end
  end

  def type
    entity.class.to_s
  end

  def id
    entity.id.to_s
  end
end
