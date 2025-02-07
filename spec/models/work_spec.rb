require "rails_helper"

RSpec.describe Work, type: :model do

  before :each do
    @hurdygurdy = create(:instrument, name: "hurdygurdy")
  end

  after :each do
    Genre.destroy_all
    Instrument.destroy_all
  end

  context "on creation" do
    it "has a title" do
      genre = create(:genre)
      work = build(:work, title: nil, genre: genre)
      work.add_instruments({ @hurdygurdy => 1 })
      expect(work.valid?).to be false
      work.title = Cicero.words(6)
      expect(work.valid?).to be true
    end

    it "has a genre" do
      work = build(:work, genre: nil)
      work.add_instruments({ @hurdygurdy => 1 })
      expect(work.valid?).to be false
      genre = create(:genre)
      work.genre = genre
      expect(work.valid?).to be true
    end

    it "has a year of composition" do
      genre = create(:genre)
      work = build(:work, genre: genre, composed_in: nil)
      work.add_instruments({ @hurdygurdy => 1 })
      expect(work.valid?).to be false
      work.composed_in = 2010
      expect(work.valid?).to be true
    end

    it "does not need a score" do
      genre = create(:genre)
      work = build(:work, score_link: nil, genre: genre)
      work.add_instruments({ @hurdygurdy => 1 })
      expect(work.valid?).to be true
    end

    it "has an ascap status" do
      genre = create(:genre)
      work = build(:work, genre: genre)
      expect(work.ascap?).to be false
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

    it "raises an error if the file host variable is not set" do
      if !ENV['FILE_ROOT'].nil?
        original_file_root = ENV['FILE_ROOT']
      else
        original_file_root = nil
        ENV['FILE_ROOT'] = 'recordings/mp3'
      end
      genre = create(:genre)
      sonata = build(:work, genre_id: genre.id, recording_link: 'sonata.mp3')
      expect { sonata.formatted_recording_link }.to raise_error(RuntimeError)
      Genre.destroy_all
      ENV['FILE_ROOT'] = original_file_root
    end

    it "raises an error if the file root variable is not set" do
      if !ENV['FILE_HOST'].nil?
        original_file_host = ENV['FILE_HOST']
      else
        original_file_host = nil
        ENV['FILE_HOST'] = 'ourserver.com'
      end
      genre = build(:genre)
      concerto = build(:work, genre_id: genre.id, recording_link: 'foobar.mp3')
      expect { concerto.formatted_recording_link }.to raise_error(RuntimeError)
      Genre.destroy_all
      ENV['FILE_HOST'] = original_file_host
    end

    it "correctly formats the link to the score" do
      if !ENV['FILE_ROOT'].nil?
        original_file_root = ENV['FILE_ROOT']
      else
        original_file_root = nil
        ENV['FILE_ROOT'] = 'recordings/mp3'
      end
      if !ENV['FILE_HOST'].nil?
        original_file_host = ENV['FILE_HOST']
      else
        original_file_host = nil
        ENV['FILE_HOST'] = 'ourserver.com'
      end
      genre = create(:genre)
      suite = build(:work, genre_id: genre.id, score_link: 'foobar.pdf')
      expect(suite.formatted_score_link).to match(/foobar\.pdf/)
      Genre.destroy_all
      ENV['FILE_ROOT'] = original_file_root
      ENV['FILE_HOST'] = original_file_host
    end
  end
end
