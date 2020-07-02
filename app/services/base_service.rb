class BaseService
  include ActiveModel::Model

  def self.call(args = nil)
    new(args).call
  end

  def self.call!(args = nil)
    new(args).call!
  end

  def call
  end

  def call!
    validate!
    call
  end
end
