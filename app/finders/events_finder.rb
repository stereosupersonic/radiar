class EventsFinder
  include ActiveModel::Model

  FILTERS = %i[name state station_id].freeze
  attr_accessor(*FILTERS)

  def call
    Event
      .order("ID DESC")
      .merge(name_filter)
      .merge(state_filter)
      .merge(station_filter)
  end

  private

  def name_filter
    if name.present?
      Event.where(name: name)
    else
      Event.all
    end
  end

  def state_filter
    if state.present?
      Event.where(state: state)
    else
      Event.all
    end
  end

  def station_filter
    if station_id.present?
      Event.where(station_id: station_id)
    else
      Event.all
    end
  end
end
