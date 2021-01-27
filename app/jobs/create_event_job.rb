class CreateEventJob < ApplicationJob
  queue_as :low

  def perform(name:, state:, done_at:, data:, duration:, track: nil, track_info: nil, station: nil, meta_data: {})
    Event.create!(
      name: name,
      track: track,
      track_info: track_info,
      station: station,
      state: state,
      done_at: done_at,
      data: data,
      duration: duration,
      meta_data: meta_data
    )
  end
end
