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

    def links
      raise ArgumentError, 'No block given' unless block_given?

      define_method :links do
        yield data
      end
    end

    def has_one(relation)
      raise ArgumentError, 'No block given' unless block_given?

      define_method relation do
        yield data
      end
    end
  end

  attr_reader :data

  def initialize(data, include: [])
    @data = data
    @include = include
  end

  def serialize
    result = data.is_a?(Enumerable) ? data.map { |e| self.class.new(e).to_h } : to_h
    { data: result }
  end

  def to_h
    raise NoMethodError if data.is_a?(Enumerable)

    result = {}
    add_type(result)
    add_id(result)
    add_attributes(result)
    add_links(result)
    add_relatioship(result)
    result
  end

  private

  def add_relatioship(result)
    result[:relationships] = {} unless @include.empty?
    result[:included] = [] unless @include.empty?
    @include.each do |include|
      raise NoMethodError unless respond_to?(include)

      included_entity = send(include)
      result[:included] << included_entity[:data]

      included_relationship = {}
      included_relationship[:data] = included_entity[:data].slice(:id, :type)
      result[:relationships][include] = included_relationship
    end
  end

  def add_links(result)
    result[:links] = links if respond_to?(:links)
  end

  def add_type(result)
    result[:type] = respond_to?(:type) ? type : default_type
  end

  def add_id(result)
    result[:id] = respond_to?(:id) ? id : default_id
  end

  def add_attributes(result)
    return unless respond_to?(:attributes)

    result_attributes = attributes.each_with_object({}) do |attr, acc|
      acc[attr] = get_attribute(attr)
    end
    result[:attributes] = result_attributes
  end

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
