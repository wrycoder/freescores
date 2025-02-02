require "rails_helper"

def build_catalog
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
end

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
      build_catalog
      get works_path
      expect(response.status).to eq(200)
      Work.destroy_all
      expect(Work.count).to eq(0)
      expect(Part.count).to eq(0)
    end

    it "sorts by genre_id" do
      build_catalog
      get works_path({ :sort_key => :genre_id })
      page = Nokogiri::HTML(response.body)
      first_record = Work.order(:genre_id).first
      first_item = page.css('.works_list_row_1')[0]
      title = first_item.children[1].children[0]
      expect(title).to match(/#{first_record.title}/)
      Work.destroy_all
      expect(Work.count).to eq(0)
      expect(Part.count).to eq(0)
    end

    it "sorts by year composed, descending" do
      build_catalog
      get works_path({ :sort_key => :composed_in, :descending => true })
      page = Nokogiri::HTML(response.body)
      first_record = Work.order(:composed_in).last
      first_item = page.css('.works_list_row_1')[0]
      title = first_item.children[1].children[0]
      expect(title).to match(/#{first_record.title}/)
      Work.destroy_all
      expect(Work.count).to eq(0)
      expect(Part.count).to eq(0)
    end
  end
end
