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

  def initialize(object)
    object.instance_of?(Array) ? @entities = object : @entity = object
  end

  def to_h
    data = @entities ? data_for_array : data_for_single_entity
    { data: data }
  end

  def data_for_array
    result_data = []
    @entities.each do |entity|
      @entity = entity
      result_attributes = {}
      attributes.each do |attr|
        result_attributes[attr] = get_attribute(attr)
      end
      result_data.push({ type: type, id: id, attributes: result_attributes })
    end
    result_data
  end

  def data_for_single_entity
    result_attributes = {}
    attributes.each do |attr|
      result_attributes[attr] = get_attribute(attr)
    end
    { type: type, id: id, attributes: result_attributes }
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
