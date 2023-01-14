# frozen_string_literal: true

class ApplicationSerializer
  attr_reader :entity

  def self.attributes(*args)
    define_method :attributes do
      args
    end
  end

  def initialize(entity)
    @entity = entity
  end


  def to_h
    result = {}
    attributes.each do |attr|
      result[attr] =
        if respond_to?(attr)
          self.send(attr)
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
      entity.id
    end

    result
  end
end