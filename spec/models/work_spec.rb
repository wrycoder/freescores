require "rails_helper"

RSpec.describe Work, type: :model do

  before :each do
    @hurdygurdy = create(:instrument, name: "hurdygurdy")
  end

  after :each do
    Work.destroy_all
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
      work = build(:work, genre: genre)
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

    it "is or is not written for a given instrument" do
      genre = create(:genre, name: "duo sonata", vocal: false)
      work_1 = build(:work, genre_id: genre.id)
      work_2 = build(:work, genre_id: genre.id)
      work_3 = build(:work, genre_id: genre.id)
      mandolin = create(:instrument, name: "mandolin")
      violin = create(:instrument, name: "violin")
      piano = create(:instrument, name: "piano")
      work_1.add_instruments({mandolin => 1, violin => 1})
      work_2.add_instruments({violin => 1, piano => 1})
      work_3.add_instruments({mandolin => 1, piano => 1})
      work_1.save!
      work_2.save!
      work_3.save!
      expect(work_1.written_for?("piano")).to be false
      expect(work_1.written_for?("mandolin")).to be true
      expect(work_2.written_for?("violin")).to be true
      expect(work_2.written_for?("piano")).to be true
      expect(work_3.written_for?("violin")).to be false
      expect(work_3.written_for?("mandolin")).to be true
    end

    it "can have multiple scopes" do
      trio_genre = create(:genre, name: "Piano Trio", vocal: false)
      solo_genre = create(:genre, name: "Solo Sonata", vocal: false)
      cello = create(:instrument, name: "cello",
        rank: 200, family: "strings")
      piano = create(:instrument, name: "piano",
        rank: 500, family: "keyboard")
      violin = create(:instrument, name: "violin",
        rank: 100, family: "strings")
      unrecorded_work = build(:work,
        genre: trio_genre,
        title: Cicero.words(5),
        composed_in: 1969)
      recorded_work = build(:work,
        genre: trio_genre,
        title: Cicero.words(6),
        composed_in: 2003)
      cello_work = build(:work,
        genre: solo_genre,
        title: Cicero.words(4),
        composed_in: 2011)
      hurdygurdy_work = build(:work,
        genre: solo_genre,
        title: Cicero.words(7),
        composed_in: 2018)
      unrecorded_work.add_instruments({
        violin => 1,
        cello => 1,
        piano => 1})
      unrecorded_work.save!
      recorded_work.add_instruments({
        violin => 1,
        cello => 1,
        piano => 1})
      recorded_work.save!
      rec = recorded_work.recordings.build
      rec.file_name = Cicero.words(1) + '.mp3'
      rec.label = Cicero.words(4)
      rec.save!
      cello_work.add_instruments({ cello => 1 })
      cello_work.save!
      cello_work.recordings.create!(
        label: cello_work.title,
        file_name: Cicero.words(1) + '.mp3')
      hurdygurdy_work.add_instruments({ @hurdygurdy => 1 })
      hurdygurdy_work.save!
      expect(Work.all.count).to eq(4)
      expect(Work.recorded.length).to eq(2)
      expect(Work.recorded.count).to eq(2)
      expect(Work.recorded.first.id).to eq(recorded_work.id)
      sorted_parts = unrecorded_work.parts
          .sort { |a,b| a.instrument_rank <=> b.instrument_rank }
      expect(sorted_parts.first.instrument.name).to match(/violin/)
      expect(unrecorded_work.parts.last.instrument.name).to match(/piano/)
    end

    it "can be sorted and filtered in various ways" do
      ["piano trio", "symphony", "solo concerto", "sonata"].each do |n|
        create(:genre, name: n)
      end
      [ ["orchestra", 800],
        ["violin", 350],
        ["viola", 360],
        ["cello", 370],
        ["piano", 400],
        ["contrabass", 380],
        ["horn", 210],
        ["trombone", 240]].each do |n, r|
        create(:instrument, name: n, rank: r)
      end
      violin = Instrument.find_by_name("violin")
      cello = Instrument.find_by_name("cello")
      piano = Instrument.find_by_name("piano")
      3.times do
        w = build(:work,
          genre: Genre.find_by_name("piano trio"))
        w.add_instruments({
          cello => 1,
          piano => 1,
          violin => 1
        })
        w.save!
      end
      2.times do
        orchestra = Instrument.find_by_name("orchestra")
        w = build(:work,
          genre: Genre.find_by_name("symphony"))
        w.add_instruments({ orchestra => 1 })
        w.save!
      end
      ["violin", "horn", "piano", "cello"].each do |i|
        instrument = Instrument.find_by_name(i)
        orchestra = Instrument.find_by_name("orchestra")
        sonata = build(:work,
          genre: Genre.find_by_name("sonata"))
        sonata.add_instruments({ instrument => 1 })
        sonata.save!
        concerto = build(:work,
          genre: Genre.find_by_name("solo concerto"))
        concerto.add_instruments({
          instrument => 1,
          orchestra => 1
        })
        concerto.save!
      end
      expect(Work.count).to eq(13)
      sonata_genre = Genre.find_by_name("sonata")
      symphony_genre = Genre.find_by_name("symphony")
      horn = Instrument.find_by_name("horn")
      first_work = Work.all.sort.first
      expect(first_work.genre).to eq(sonata_genre)
      expect(first_work.parts.sort.first.instrument).to eq(horn)
      last_work = Work.all.sort.last
      expect(last_work.genre).to eq(symphony_genre)
      expect(Work.solo.length).to eq(6)
    end

    it "raises an error if the file host variable is not set" do
      if !ENV['FILE_ROOT'].nil?
        original_file_root = ENV['FILE_ROOT']
      else
        original_file_root = nil
        ENV['FILE_ROOT'] = 'recordings/mp3'
      end
      genre = create(:genre)
      sonata = build(:work, genre_id: genre.id)
      expect { sonata.formatted_recording_links }.to raise_error(RuntimeError)
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
      concerto = build(:work, genre_id: genre.id)
      expect { concerto.formatted_recording_links }.to raise_error(RuntimeError)
      Genre.destroy_all
      ENV['FILE_HOST'] = original_file_host
    end

    it "correctly formats the links to the score" do
      if !ENV['FILE_ROOT'].nil?
        original_file_root = ENV['FILE_ROOT']
      else
        original_file_root = nil
        ENV['FILE_ROOT'] = 'recordings/mp3'
      end
      if !ENV['MEDIA_HOST'].nil?
        original_media_host = ENV['MEDIA_HOST']
      else
        original_media_host = nil
        ENV['MEDIA_HOST'] = 'http://ourserver.com'
      end
      genre = create(:genre)
      suite = build(:work, genre_id: genre.id)
      suite.add_instruments({@hurdygurdy => 1 })
      suite.save!
      suite.scores.create!(
        file_name: "foobar.pdf",
        label: "Score for #{suite.title}")
      suite.formatted_score_links do |arr|
        expect(arr[1]).to match(/foobar\.pdf/)
      end
      Genre.destroy_all
      ENV['FILE_ROOT'] = original_file_root
      ENV['MEDIA_HOST'] = original_media_host
    end
  end
end
