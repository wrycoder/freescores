require "rails_helper"

RSpec.describe GenresController do
  before :each do
    create(:genre, name: "Symphony", vocal: false)
    create(:genre, name: "Opera", vocal: true)
    create(:genre, name: "Sonata", vocal: false)
    create(:genre, name: "Piano Trio", vocal: false)
    create(:genre, name: "Part Song", vocal: true)
  end

  context "viewing" do
    it "shows all existing genres" do
      get genres_path
      page = Nokogiri::HTML(response.body)
      genre_rows = page.css('.genre')
      expect(genre_rows.length).to eq(5)
    end

    it "shows all works created in a specific genre" do
      define_environment
      symphony_genre = Genre.find_by_name("Symphony")
      sonata_genre = Genre.find_by_name("Sonata")
      symphony = build(:work, genre: symphony_genre,
        title: "Symphony No. 104")
      orchestra = create(:instrument, name: "Orchestra", rank: 410)
      symphony.add_instruments({ orchestra => 1 })
      symphony.save!
      sonata = build(:work, genre: sonata_genre,
        title: "Piano Sonata No. 76")
      piano = create(:instrument, name: "Piano", rank: 405)
      sonata.add_instruments({ piano => 1 })
      sonata.save!
      get genre_path(symphony_genre)
      expect(response).to have_http_status(:success)
      expect(response.body).to match(/#{symphony.title}/)
      expect(response.body).to_not match(/#{sonata.title}/)
      clear_environment
    end
  end

  context "adding" do
    it "can only be done by an authorized user" do
      get new_genre_path 
      expect(response).to have_http_status(:redirect)
      expect(flash[:alert]).to match(/Please log in/)
      follow_redirect!
      ENV["ADMIN_PASSWORD"] = 'password'
      log_in_through_controller
      get new_genre_path 
      expect(response).to have_http_status(:success)
      get sessions_destroy_path
      ENV["ADMIN_PASSWORD"] = nil
    end

    it "creates a genre" do
      ENV["ADMIN_PASSWORD"] = 'password'
      log_in_through_controller
      initial_genre_count = Genre.count
      post genres_path( :params => {
        :genre => {
          :name => "Saw Concerto",
          :vocal => false
        }
      })
      expect(Genre.count)
        .to eq(initial_genre_count + 1)
      get sessions_destroy_path
      ENV["ADMIN_PASSWORD"] = nil
    end

    it "does not allow an invalid genre to be created" do
      ENV["ADMIN_PASSWORD"] = 'password'
      log_in_through_controller
      initial_genre_count = Genre.count
      post genres_path( :params => {
        :genre => {
          :name => "Symphony",
          :vocal => false
        }
      })
      expect(flash[:alert]).to match(
        /Validation failed: Name has already been taken/)
      expect(Genre.count)
        .to eq(initial_genre_count)
      get sessions_destroy_path
      ENV["ADMIN_PASSWORD"] = nil
    end
  end
end
