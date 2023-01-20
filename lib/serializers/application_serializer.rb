# frozen_string_literal: true

# All app serializers must be subclasses of ApplicationSerializer
class ApplicationSerializer
  class << self
    def attributes(*args)
      define_method :attributes do
        args
      end
    end

    def type(type)
      define_method :type do
        type.to_s
      end
    end

    def id
      raise ArgumentError, 'No block given' unless block_given?

      define_method :id do
        yield data
      end
    end
  end

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def serialize
    result = data.is_a?(Enumerable) ? data.map { |e| self.class.new(e).to_h } : to_h
    { data: result }
  end

  def to_h
    raise NoMethodError if data.is_a?(Enumerable)

    result_attributes = attributes.each_with_object({}) do |attr, acc|
      acc[attr] = get_attribute(attr)
    end
    data_type = respond_to?(:type) ? type : default_type
    data_id = respond_to?(:id) ? id : default_id
    { type: data_type, id: data_id, attributes: result_attributes }
  end

  private

  def default_type
    data.class.to_s.downcase
  end

  def default_id
    data.id.to_s
  end

  def get_attribute(attr)
    if respond_to?(attr)
      send(attr)
    elsif data.respond_to?(attr)
      data.send(attr)
    else
      raise NoMethodError, "Undefined serialize key #{attr}"
    end
  end
end
