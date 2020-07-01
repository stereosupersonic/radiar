require "delegate"

class ApplicationPresenter < SimpleDelegator
  alias object __getobj__

  def self.wrap(collection)
    collection.map { |elem| new(elem) }
  end

  def helpers
    ApplicationController.helpers
  end

  def created_at
    h.format_datetime o.created_at
  end

  alias h helpers
  alias o object
end
