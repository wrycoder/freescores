require "rails_helper"

RSpec.describe WorksController do
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

  before :each do
    build_catalog
    if !ENV['FILE_HOST'].nil?
      @original_file_host = ENV['FILE_HOST']
    else
      ENV['FILE_HOST'] = 'ourserver.com'
      @original_file_host = nil
    end

    if !ENV['FILE_ROOT'].nil?
      @original_file_root = ENV['FILE_ROOT']
    else
      ENV['FILE_ROOT'] = 'recordings/mp3'
      @original_file_root = nil
    end
  end

  after :each do
    Work.destroy_all
    expect(Work.count).to eq(0)
    expect(Part.count).to eq(0)
    Instrument.destroy_all
    Genre.destroy_all
    ENV['FILE_HOST'] = @original_file_host
    ENV['FILE_ROOT'] = @original_file_root
  end

  context "when displaying a single work" do
    it "shows a properly-formatted list of instruments" do
      Work.destroy_all
      Instrument.destroy_all
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
      Genre.destroy_all
    end

    it "gives a logged-in user access to the liner note" do
      ENV["ADMIN_PASSWORD"] = 'password'
      Work.destroy_all
      Instrument.destroy_all
      genre = create(:genre)
      instrument = create(:instrument)
      work = build(:work, genre_id: genre.id)
      work.add_instruments({ instrument => 1 })
      work.save!
      get work_path(work)
      expect(response).to have_http_status(:success)
      log_in_through_controller
      get work_path(work)
      expect(response.body).to match(/#{work.title}/)
      expect(response.body).to match(/Add Liner Note/)
      ln = create(:liner_note, work_id: work.id,
                  note: Cicero.words(50))
      get work_path(work)
      expect(response.body).to match(/Edit Liner Note/)
      Work.destroy_all
      Instrument.destroy_all
      Genre.destroy_all
      ENV['ADMIN_PASSWORD'] = nil
    end
  end

  context "when displaying multiple works" do
    it "shows all existing works" do
      get works_path
      expect(response.status).to eq(200)
    end

    it "sorts by genre_id" do
      get works_path({ :sort_key => :genre_id, :order => :ascending })
      page = Nokogiri::HTML(response.body)
      first_record = Work.order(:genre_id).first
      first_item = page.css('.works_list_row_1')[0]
      title_node = first_item.children[1].children[1].children[0]
      expect(title_node).to match(/#{first_record.title}/)
    end

    it "sorts by year composed, descending" do
      get works_path({ :sort_key => :composed_in, :order => :descending })
      page = Nokogiri::HTML(response.body)
      first_record = Work.order(:composed_in).last
      first_item = page.css('.works_list_row_1')[0]
      title_node = first_item.children[1].children[1].children[0]
      expect(title_node).to match(/#{first_record.title}/)
    end
  end

  context "when creating new works" do
    it "screens for duplicates" do
      ENV["ADMIN_PASSWORD"] = 'password'
      log_in_through_controller
      genre = Genre.where(vocal: false).first
      instrument = Instrument.first
      title = "Something Fancy"
      work = build(:work, title: title, genre_id: genre.id)
      work.add_instruments({ instrument => 1 })
      work.save!
      post works_path, params: {
        work: {
          genre_id: genre.id,
          title: title,
          score_link: "fancy.pdf",
          composed_in: 1978,
          parts_attributes: {
            "0": { "instrument_id": instrument.id,
                   "quantity": 1 },
            "1": { "instrument_id": "",
                   "quantity": 1 },
            "2": { "instrument_id": "",
                   "quantity": 1 },
            "3": { "instrument_id": "",
                   "quantity": 1 },
            "4": { "instrument_id": "",
                   "quantity": 1 },
            "5": { "instrument_id": "",
                   "quantity": 1 },
          }
        }
      }
      expect(response).to have_http_status(:bad_request)
      expect(flash[:alert]).to match(/That title is already taken/)
      ENV["ADMIN_PASSWORD"] = nil
    end

    it "correctly validates lyricist" do
      ENV["ADMIN_PASSWORD"] = 'password'
      initial_work_count = Work.count
      genre = create(:genre, name: 'Art Song', vocal: true)
      soprano = create(:instrument, name: 'soprano', family: 'vocal')
      piano = Instrument.find_by_name('piano')
      log_in_through_controller
      post works_path, params: {
        work: {
          genre_id: genre.id,
          title: 'Bada Bing',
          score_link: "bada_bing.pdf",
          composed_in: 1974,
          parts_attributes: {
            "0": { "instrument_id": soprano.id,
                   "quantity": 1 },
            "1": { "instrument_id": piano.id,
                   "quantity": 1 },
            "2": { "instrument_id": "",
                   "quantity": 1 },
            "3": { "instrument_id": "",
                   "quantity": 1 },
            "4": { "instrument_id": "",
                   "quantity": 1 },
            "5": { "instrument_id": "",
                   "quantity": 1 },
          }
        }
      }
      expect(response).to have_http_status(:bad_request)
      expect(flash[:alert]).to match(/The music could not be added/)
      expect(Work.count).to eq(initial_work_count)
      ENV["ADMIN_PASSWORD"] = nil
    end

    it "accurately handles instrumental parts" do
      initial_work_count = Work.count
      initial_part_count = Part.count
      valid_work = Work.first
      ENV["ADMIN_PASSWORD"] = 'password'
      log_in_through_controller
      post works_path, params: {
        work: {
          genre_id: Genre.first.id,
          title: Cicero.words(3),
          score_link: "foo_bar.pdf",
          composed_in: 1996,
          parts_attributes: {
            "0": { "instrument_id": "83", # THIS IS INVALID
                   "quantity": 1 },
            "1": { "instrument_id": valid_work.id,
                   "quantity": 1 },
            "2": { "instrument_id": "",
                   "quantity": 1 },
            "3": { "instrument_id": "",
                   "quantity": 1 },
            "4": { "instrument_id": "",
                   "quantity": 1 },
            "5": { "instrument_id": "",
                   "quantity": 1 },
          }
        }
      }
      expect(response).to have_http_status(:bad_request)
      expect(Work.count).to eq(initial_work_count)
      expect(Part.count).to eq(initial_part_count)
      post works_path, params: {
        work: {
          genre_id: Genre.first.id,
          title: Cicero.words(4),
          score_link: "more_music,pdf",
          composed_in: 1978,
          parts_attributes: {
            "0": { "instrument_id": Instrument.first.id,
                   "quantity": 1 },
            "1": { "instrument_id": Instrument.last.id,
                   "quantity": 1 },
            "2": { "instrument_id": "",
                   "quantity": 1 },
            "3": { "instrument_id": "",
                   "quantity": 1 },
            "4": { "instrument_id": "",
                   "quantity": 1 },
            "5": { "instrument_id": "",
                   "quantity": 1 }
          }
        }
      }
      expect(response).to have_http_status(:success)
      expect(Work.count).to eq(initial_work_count + 1)
      expect(Part.count).to eq(initial_part_count + 2)
      Work.destroy_all
      expect(Part.count).to eq(0)
      ENV["ADMIN_PASSWORD"] = nil
    end
  end

  context "when editing existing works" do
    it "finds the right work" do
      ENV["ADMIN_PASSWORD"] = 'password'
      expect { get edit_work_url }.to raise_error(
        ActionController::UrlGenerationError)
      get edit_work_url(Work.first.id)
      expect(response).to have_http_status(:redirect)
      log_in_through_controller
      get edit_work_url(Work.first.id)
      expect(response).to have_http_status(:success)
      expect(response.body).to match(/Composed in/)
      expect(response.body).to match(/Revised in/)
      ENV["ADMIN_PASSWORD"] = nil
    end

    it "updates a work correctly" do
      test_work = Work.first
      expect(test_work.revised_in.nil?).to be true
      ENV["ADMIN_PASSWORD"] = 'password'
      log_in_through_controller
      patch work_url({:id => test_work.id}), params: {
        :work => {
          :revised_in => 2013,
          :ascap => true
        }
      }
      expect(response).to have_http_status(:success)
      test_work.reload
      expect(test_work.revised_in).to eq(2013)
      expect(test_work.ascap?).to be true
      ENV["ADMIN_PASSWORD"] = nil
    end
  end
end
