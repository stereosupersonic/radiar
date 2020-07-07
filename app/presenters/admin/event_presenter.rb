module Admin
  class EventPresenter < ApplicationPresenter
    def done_at
      h.format_datetime o.done_at
    end
  end
end
