require "rails_helper"

RSpec.describe WorksController do
  context "when displaying a work" do
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
end
