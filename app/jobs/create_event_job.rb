class CreateEventJob < ApplicationJob
  queue_as :low

  def perform(name:, state:, done_at:, data:, duration:, track:, meta_data: {})
    Event.create!(
      name: name,
      track: track,
      state: state,
      done_at: done_at,
      data: data,
      duration: duration,
      meta_data: meta_data
    )
  end
end
