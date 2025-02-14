require 'rails_helper'

RSpec.describe "Recordings", type: :request do
  before :each do
    create(:genre)
    create(:instrument)
    @test_work = build(:work, genre: Genre.first)
    @test_work.add_instruments({ Instrument.first => 1 })
    @test_work.save!
    define_environment
  end

  after :each do
    Work.destroy_all
    Genre.destroy_all
    Instrument.destroy_all
    clear_environment
  end

  context "Adding recordings" do
    it "can only be done by an authorized user" do
      get new_work_recording_path(@test_work)
      expect(response).to have_http_status(:redirect)
      expect(flash[:alert]).to match(/Please log in/)
      follow_redirect!
      ENV["ADMIN_PASSWORD"] = 'password'
      log_in_through_controller
      get new_work_recording_path(@test_work)
      expect(response).to have_http_status(:success)
      get sessions_destroy_path
      ENV["ADMIN_PASSWORD"] = nil
    end

    it "works without errors" do
      initial_recording_count = Recording.count
      ENV["ADMIN_PASSWORD"] = 'password'
      log_in_through_controller
      post work_recordings_path(@test_work), params: {
        recording: {
          label: "1. Allegro",
          file_name: "allegro.mp3"
        }
      }
      expect(response).to have_http_status(:redirect)
      expect(Recording.count)
        .to eq(initial_recording_count + 1)
      follow_redirect!
      expect(response.body).to match(/#{@test_work.title}/)
      ENV["ADMIN_PASSWORD"] = nil
    end

    it "handles invalid data correctly" do
      initial_recording_count = Recording.count
      ENV["ADMIN_PASSWORD"] = 'password'
      log_in_through_controller
      post work_recordings_path(@test_work), params: {
        recording: {
          label: "Recording of First Movement",
          file_name: "music.xls"
        }
      }
      expect(Recording.count).to eq(initial_recording_count)
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to match(/must be MP3/)
      ENV["ADMIN_PASSWORD"] = nil
    end
  end

  context "Destroying recordings" do
    it "can be done without errors" do
      test_recording = create(
        :recording,
        file_name: "testrec.mp3",
        work: @test_work)
      initial_recording_count = Recording.count
      ENV["ADMIN_PASSWORD"] = 'password'
      log_in_through_controller
      delete recording_path(test_recording)
      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to match(/Recording deleted/)
      follow_redirect!
      expect(response.body).to match(/#{@test_work.title}/)
      expect(Recording.count).to eq(initial_recording_count - 1)
      ENV["ADMIN_PASSWORD"] = nil
    end
  end
end
