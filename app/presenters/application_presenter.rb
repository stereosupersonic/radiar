require "delegate"

class ApplicationPresenter < SimpleDelegator
  alias_method :object, :__getobj__

  def self.wrap(collection)
    collection.map { |elem| new(elem) }
  end

  def helpers
    ApplicationController.helpers
  end

  def created_at
    h.format_datetime o.created_at
  end

  alias_method :h, :helpers
  alias_method :o, :object
end
