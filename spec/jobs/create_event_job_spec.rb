require "rails_helper"

RSpec.describe CreateEventJob, type: :job do
  subject(:job) { CreateEventJob.new }

  let(:track) { FactoryBot.create :track }

  it "creates an event record" do
    expect {
      job.perform(name: :google_search,
                  state: :ok,
                  done_at: Time.current,
                  data: {year: "2019"},
                  duration: 1,
                  meta_data: {status_code: 200},
                  track: track)
    }.to change(Event, :count).by(1)

    event = Event.last

    expect(event.name).to eq "google_search"
    expect(event.duration).to eq 1.0
    expect(event.data["year"]).to eq "2019"
    expect(event.meta_data["status_code"]).to eq 200
  end
end
