ActiveSupport::Notifications.subscribe(:log_api_request) do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  ok = event.payload[:status].to_s.strip.downcase == "ok"

  CreateEventJob.perform_later(
    name: event.payload[:event_name],
    state: (ok ? :ok : :failed),
    done_at: event.end,
    data: event.payload[:data],
    duration: event.duration,
    meta_data: event.payload.except(:data)
  )
end
