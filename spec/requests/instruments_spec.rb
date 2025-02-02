require 'rails_helper'

RSpec.describe "Instruments", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get new_instrument_path
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "POST /create" do
    it "returns http success" do
      post instruments_path
      expect(response).to have_http_status(:redirect)
      ENV["ADMIN_PASSWORD"] = 'password'
      log_in_through_controller
      post instruments_path( :params => {
        :instrument => {
          :name => "accordion",
          :family => "reeds",
          :rank => 7
        }
      })
      i = Instrument.order(:created_at).last
      expect(i.name).to match(/accordion/)
      expect(i.rank).to eq(7)
      get sessions_destroy_path
      ENV["ADMIN_PASSWORD"] = nil
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get instrument_path({:id => 999})
      expect(response).to have_http_status(:redirect)
      expect(flash.empty?).to be false
      harmonica = create(:instrument, name: "harmonica")
      get instrument_path({:id => harmonica.id})
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      congas = create(:instrument, name: "congas", family: "percussion")
      harp = create(:instrument, name: "harp", family: "strings")
      trombone = create(:instrument, name: "trombone", family: "brass")
      get instruments_path
      expect(response).to have_http_status(:success)
      [congas, harp, trombone].each do |instrument|
        expect(response.body).to match(/#{instrument.name}/)
        expect(response.body).to match(/#{instrument.family}/)
      end
    end
  end

  describe "PATCH /update" do
    it "returns http success" do
      ENV["ADMIN_PASSWORD"] = 'password'
      log_in_through_controller
      maracas = create(:instrument, name: "maracas")
      patch instrument_url({:id => maracas.id}), params: {
        :instrument => {
          :rank => 8,
          :family => "percussion"
        }
      }
      expect(response).to have_http_status(:success)
      maracas.reload
      expect(maracas.family).to match(/percussion/)
      expect(maracas.rank).to eq(8)
      get sessions_destroy_path
      ENV["ADMIN_PASSWORD"] = nil
    end
  end

end
