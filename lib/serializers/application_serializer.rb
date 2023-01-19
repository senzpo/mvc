# frozen_string_literal: true

# All app serializers must be subclasses of ApplicationSerializer
class ApplicationSerializer
  class EntitySerializer
    attr_reader :entity, :attributes

    def initialize(entity, attributes)
      @entity = entity
      @attributes = attributes
    end

    def to_h
      result_attributes = {}
      attributes.each do |attr|
        result_attributes[attr] = get_attribute(attr)
      end
      { type: type, id: id, attributes: result_attributes }
    end

    private

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
      entity.class.to_s.downcase
    end

    def id
      entity.id.to_s
    end
  end

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def to_h
    result = data.instance_of?(Array) ? data.map { |e| EntitySerializer.new(e, attributes).to_h } : EntitySerializer.new(data, attributes).to_h
    { data: result }
  end

  def self.attributes(*args)
    define_method :attributes do
      args
    end
  end
end
