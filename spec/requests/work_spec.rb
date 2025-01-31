require "rails_helper"

RSpec.describe WorksController do
  context "when displaying a single work" do
    it "shows a properly-formatted list of instruments" do
      violin = create(:instrument,
              name: "violin",
              family: "strings",
              rank: 750)
      cello = create(:instrument,
              name: "cello",
              family: "strings",
              rank: 775)
      piano = create(:instrument,
              name: "piano",
              family: "keyboard",
              rank: 800)
      genre = create(:genre, name: "Piano Trio")
      work = build(:work, genre_id: genre.id)
      work.add_instruments({violin => 1, cello => 1, piano => 1})
      work.save!
      get "/works/#{work.id}"
      expect(response.body).to match(/violin, cello, and piano/)
    end
  end

  context "when displaying multiple works" do
    it "shows all existing works" do
      trombone = create(:instrument,
              name: "trombone",
              family: "brass",
              rank: 510)
      oboe = create(:instrument,
              name: "oboe",
              family: "woodwinds",
              rank: 480)
      piano = create(:instrument,
              name: "piano",
              family: "keyboard",
              rank: 900)
      genre = create(:genre, name: "Miscellaneous Chamber Music")
      3.times do
        w = build(:work, genre_id: genre.id)
        w.add_instruments({ oboe => 1, piano => 1})
        w.save!
      end
      2.times do
        w = build(:work, genre_id: genre.id)
        w.add_instruments({ trombone => 1, oboe => 1, piano => 1 })
        w.save!
      end
      get "/works"
      expect(response.status).to eq(200)
    end
  end
end
