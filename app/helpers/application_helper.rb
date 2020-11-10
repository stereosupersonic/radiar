module ApplicationHelper
  def all_tags
    Rails.cache.fetch("all_tags-v1", expires_in: 30.minutes) do
      tags = TrackInfo.pluck(:tags).map(&:first)
      tags = {}.tap do |result|
        tags.flatten.reject(&:blank?).each do |tag|
          result[tag] ||= 0
          result[tag] += 1
        end
      end
      tags.sort_by { |_k, v| v }.reverse.map(&:first)[0...150]
    end
  end

  def all_years
    Rails.cache.fetch("all_years-v1", expires_in: 30.minutes) do
      TrackInfo.distinct.pluck(:year).compact.sort.reverse.insert(0, :without)
    end
  end

  def all_event_names
    Rails.cache.fetch("all_event_names-v1", expires_in: 30.minutes) do
      Event.distinct.pluck(:name).compact.sort
    end
  end

  # date/time
  def format_time(time)
    time&.strftime "%H:%M"
  end

  def format_date(date)
    date&.strftime "%d.%m.%Y"
  end

  def format_datetime(date)
    date&.strftime "%d.%m.%Y %H:%M"
  end

  # buttons
  def icon_tag(icon, options = {})
    html_class = "fa fa-#{icon} " + options[:class].to_s
    content_tag(:i, "&nbsp;".html_safe, class: html_class)
  end

  def button_with_icon(link, text, icon, options = {})
    options.reverse_merge! class: "btn btn-default"
    link_to icon_tag(icon) + text, link, options
  end

  def show_button(link, text = "Show", options = {})
    options.reverse_merge! class: "btn btn-info"
    button_with_icon link, text, "link", options
  end

  def add_button(link, text = "Add", options = {})
    options.reverse_merge! class: "btn btn-primary add-button"
    button_with_icon link, text, "plus", options
  end

  def edit_button(link, text = "Edit", options = {})
    link = link.is_a?(ActiveRecord::Base) ? [:edit, link] : link
    options.reverse_merge! class: "btn btn-primary"
    button_with_icon link, text, "pencil-alt", options
  end

  def submit_button(text = "Save", options = {})
    options.reverse_merge! class: "btn btn-success", type: "submit"
    button_tag options do
      icon_tag(:check) + safe_join([text])
    end
  end

  def remove_button(link, text = "Remove", options = {})
    options.reverse_merge! data: {confirm: "Are you sure?"}, class: "btn btn-danger"
    button_with_icon link, text, "trash", options
  end

  def delete_button(link, text = "Delete", options = {})
    options.reverse_merge! data: {confirm: "Are you sure?"},
                           method: :delete, class: "btn btn-danger"
    button_with_icon link, text, "trash", options
  end

  def back_button(link = :back, text = "Back", options = {})
    options.reverse_merge! class: "btn btn-default"
    button_with_icon link, text, "arrow-left", options
  end

  def cancel_button(link = :back, text = "Cancel", options = {})
    options.reverse_merge! class: "btn btn-danger"
    button_with_icon link, text, "remove", options
  end

  def show_boolean_value(value)
    if value
      icon_tag :check, class: "text-success"
    else
      icon_tag :times, class: "text-danger"
    end
  end
end
