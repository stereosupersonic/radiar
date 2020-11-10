class CreateEventJob < ApplicationJob
  queue_as :low

  def perform(name:, state:, done_at:, data:, duration:, track:, station:, meta_data: {})
    Event.create!(
      name: name,
      track: track,
      station: station,
      state: state,
      done_at: done_at,
      data: data,
      duration: duration,
      meta_data: meta_data
    )
  end
end
