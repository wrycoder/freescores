require "rails_helper"

RSpec.describe Work, type: :model do
  context "on creation" do
    it "has a title, genre, year of composition, and a score link" do
      genre = create(:genre)
      work = build(:work, composed_in: nil,
                          title: nil,
                          score_link: nil,
                          genre_id: genre.id)
      expect(work.valid?).to be false
      work.composed_in = 1950
      work.title = Cicero.words(6)
      expect(work.valid?).to be false
      work.composed_in = nil
      work.score_link = 'http://foo.bar.com/' + Cicero.words(1)
      expect(work.valid?).to be false
      work.title = nil
      work.composed_in = 1961
      expect(work.valid?).to be false
      work.score_link = nil
      work.title = Cicero.words(4)
      expect(work.valid?).to be false
      work.score_link = 'http://foo.bar.com/' + Cicero.words(1)
      i = create(:instrument)
      work.add_instruments({i => 1})
      work.genre_id = nil
      expect(work.valid?).to be false
      work.genre_id = genre.id
      expect(work.valid?).to be true
    end

    it "has at least one part" do
      initial_parts_count = Part.count
      initial_works_count = Work.count
      genre = create(:genre)
      work = build(:work, genre_id: genre.id)
      piano = create(:instrument,
                      name: "piano",
                      rank: 1000,
                      family: "keyboard")
      expect(work.valid?).to be false
      work.add_instruments({piano => 1})
      expect(work.valid?).to be true
      work.save!
      expect(Work.count).to eq(initial_works_count + 1)
      expect(Part.count).to eq(initial_parts_count + 1)
    end

    it "has a lyricist if it is vocal" do
      genre = create(:genre, name: "hymn", vocal: true)
      choir = create(:instrument,
                      name: "choir",
                      rank: 250,
                      family: "vocal ensemble")
      work = build(:work, genre_id: genre.id)
      work.add_instruments({ choir => 1 })
      expect(work.valid?).to be false
      work.lyricist = "Elmer Schlondorff"
      expect(work.valid?).to be true
    end

    it "cannot have a duplicate title" do
      genre = create(:genre)
      instrument = create(:instrument)
      work = build(:work, title: "Buttons and Bows", genre_id: genre.id)
      work.add_instruments({ instrument => 1 })
      work.save!
      duplicate = build(:work, title: "Buttons and Bows", genre_id: genre.id)
      duplicate.add_instruments({ instrument => 1})
      expect { duplicate.save! }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  context "at runtime" do
    it "can list its instruments" do
      harmonica = create(:instrument,
                      name: "harmonica",
                      rank: 7500,
                      family: "reeds")
      piano = create(:instrument,
                      name: "piano",
                      rank: 7550,
                      family: "keyboard")
      bass = create(:instrument,
                      name: "contrabass",
                      rank: 7525,
                      family: "strings")
      genre = create(:genre, name: "Miscellaneous Trio")
      work = build(:work, genre_id: genre.id)
      work.add_instruments({
        harmonica => 2,
        piano => 1,
        bass => 1
      })
      work.save!
      ensemble = work.list_instruments
      expect(ensemble.length).to eq(3)
      expect(ensemble[0][0]).to eq(2)
      expect(ensemble[1][1]).to match(/contrabass/)
      expect(ensemble[2][1]).to match(/piano/)
    end
  end
end
