require 'rails_helper'

RSpec.describe "Scores", type: :request do
  before :each do
    create(:genre)
    create(:instrument)
    @test_work = build(:work, genre: Genre.first)
    @test_work.add_instruments({ Instrument.first => 1 })
    @test_work.save!
    define_environment
  end

  after :each do
    clear_environment
    Work.destroy_all
    Genre.destroy_all
    Instrument.destroy_all
  end

  context "Adding scores" do
    it "can only be done by an authorized user" do
      get new_work_score_path(@test_work)
      expect(response).to have_http_status(:redirect)
      expect(flash[:alert]).to match(/Please log in/)
      follow_redirect!
      ENV["ADMIN_PASSWORD"] = 'password'
      log_in_through_controller
      get new_work_score_path(@test_work)
      expect(response).to have_http_status(:success)
      get sessions_destroy_path
      ENV["ADMIN_PASSWORD"] = nil
    end

    it "works without errors" do
      initial_score_count = Score.count
      ENV["ADMIN_PASSWORD"] = 'password'
      log_in_through_controller
      post work_scores_path(@test_work), params: {
        score: {
          label: "Sheet music for 1. Allegro",
          file_name: "allegro.pdf"
        }
      }
      expect(response).to have_http_status(:redirect)
      expect(Score.count)
        .to eq(initial_score_count + 1)
      follow_redirect!
      expect(response.body).to match(/#{@test_work.title}/)
      ENV["ADMIN_PASSWORD"] = nil
    end

    it "handles invalid data correctly" do
      initial_score_count = Score.count
      ENV["ADMIN_PASSWORD"] = 'password'
      log_in_through_controller
      post work_scores_path(@test_work), params: {
        score: {
          label: "First Movement Music",
          file_name: "foobar.txt"
        }
      }
      expect(Score.count).to eq(initial_score_count)
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to match(/must be in PDF/)
      ENV["ADMIN_PASSWORD"] = nil
    end
  end

  context "destroying scores" do
    it "works without errors" do
      test_score = create(
        :score,
        file_name: "allegro.pdf",
        work: @test_work)
      initial_score_count = Score.count
      ENV["ADMIN_PASSWORD"] = 'password'
      log_in_through_controller
      delete score_path(test_score)
      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(response.body).to match(/#{@test_work.title}/)
      expect(Score.count).to eq(initial_score_count - 1)
      expect(flash[:notice]).to match(/Score deleted/)
      ENV["ADMIN_PASSWORD"] = nil
    end
  end
end
