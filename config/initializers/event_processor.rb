ActiveSupport::Notifications.subscribe(:log_api_request) do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  CreateEventJob.perform_later(
    name: event.payload[:event_name],
    state: event.payload[:status].to_s.strip.downcase,
    done_at: event.end,
    data: event.payload[:data],
    duration: event.duration,
    meta_data: event.payload.except(:data),
    track: event.payload[:track]
  )

rescue => e
  CreateEventJob.perform_later(
    name: event.payload[:event_name],
    state: :exception,
    done_at: event.end,
    data: {
      status_code: event.payload[:status_code],
      exception: event.payload[:exception],
      exception_object: event.payload[:exception_object]
    },
    duration: event.duration,
    meta_data: event.payload.except(:data),
    track: event.payload[:track]
  )

  raise e
end

ActiveSupport::Notifications.subscribe(:track_info_creation) do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  CreateEventJob.perform_later(
    name: event.payload[:event_name],
    state: :ok,
    done_at: event.end,
    data: event.payload[:data],
    duration: event.duration,
    track: event.payload[:track]
  )
end
