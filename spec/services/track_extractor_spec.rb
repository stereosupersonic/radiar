require "rails_helper"

RSpec.describe TrackExtractor do
  it "returns an artist and the title seperated by - " do
    extractor = TrackExtractor.new text: "Foo Fighters - My Hero"

    response = extractor.call

    expect(response.artist).to eq "Foo Fighters"
    expect(response.title).to eq "My Hero"
  end

  it "returns an artist and the title seperated by : " do
    extractor = TrackExtractor.new text: "Foo Fighters : My Hero"

    response = extractor.call

    expect(response.artist).to eq "Foo Fighters"
    expect(response.title).to eq "My Hero"
  end

  it "returns nil when text is not valid" do
    extractor = TrackExtractor.new text: ""

    response = extractor.call

    expect(response).to be_nil
  end

  it "returns nil when text is don't contains alphanumeric" do
    extractor = TrackExtractor.new text: "Foo Fighters - :"

    response = extractor.call

    expect(response).to be_nil
  end
end
