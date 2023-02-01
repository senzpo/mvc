# frozen_string_literal: true

# Default presenter of model hash
class ApplicationPresenter
  def initialize(object)
    @object = object
    object.attributes.keys.each do |attr|
      define_singleton_method attr do
        object.send(attr)
      end
    end
  end

  def class
    @object.class
  end
end
