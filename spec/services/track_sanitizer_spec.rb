require "rails_helper"

RSpec.describe TrackSanitizer do
  it "removes fm shit" do
    sanitized = TrackSanitizer.new(text: "One Is One | Fm4 Auf Laut").call
    expect(sanitized).to eq("One Is One")
    sanitized = TrackSanitizer.new(text: "Rock Antenne").call
    expect(sanitized).to eq("")
    sanitized = TrackSanitizer.new(text: "feierabend | Fm4 Homebase").call
    expect(sanitized).to eq("Feierabend")
    sanitized = TrackSanitizer.new(text: "Grossstadtgeflã¼ster").call
    expect(sanitized).to eq("Grossstadtgeflüster")
    sanitized = TrackSanitizer.new(text: "Glã¼cksspiel").call
    expect(sanitized).to eq("Glücksspiel")
    sanitized = TrackSanitizer.new(text: "ã\x84Rzte").call
    expect(sanitized).to eq("ãrzte")
  end

  it "titlizes it" do
    sanitized = TrackSanitizer.new(text: "   Bla blah BLUB   ").call
    expect(sanitized).to eq("Bla Blah Blub")
  end

  it "removes 'Neu:'" do
    sanitized = TrackSanitizer.new(text: "Neu: Shot In The Dark").call
    expect(sanitized).to eq("Shot In The Dark")
  end
  it "removes '(Album Version)'" do
    sanitized = TrackSanitizer.new(text: "After Dark (Album Version)").call
    expect(sanitized).to eq("After Dark")
  end
end
