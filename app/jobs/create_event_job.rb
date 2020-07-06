class CreateEventJob < ApplicationJob
  queue_as :low

  def perform(name:, state:, done_at:, data:, duration:, meta_data:)
    Event.create!(
      name: name,
      state: state,
      done_at: done_at,
      data: data,
      duration: duration,
      meta_data: meta_data
    )
  end
end
