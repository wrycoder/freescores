require 'rails_helper'

RSpec.describe "LinerNotes", type: :request do

  before :each do
    ENV['ADMIN_PASSWORD'] = 'password'
    create(:genre)
    create(:instrument)
    @work = build(:work, genre: Genre.first)
    @work.add_instruments({ Instrument.first => 1 })
    @work.save!
  end

  after :each do
    ENV['ADMIN_PASSWORD'] = nil
    Work.destroy_all
    Instrument.destroy_all
    Genre.destroy_all
  end

  describe "adding new liner notes" do
    it "gives user access to liner notes interface" do
      get new_liner_note_path
      expect(response).to have_http_status(:redirect)
      log_in_through_controller
      get new_liner_note_path + "?work_id=#{@work.id}"
      expect(response).to have_http_status(:success)
      title_string = "Add liner note for #{@work.title}"
      expect(response.body).to match(/#{title_string}/)
      get new_liner_note_path + "?work_id=12352"
      expect(response).to have_http_status(:redirect)
      expect(flash[:alert]).to match(/Invalid work/)
      follow_redirect!
    end

    it "allows user to create a new liner note" do
      log_in_through_controller
      initial_note_count = LinerNote.count
      post liner_notes_path, params: {
        liner_note: {
          work_id: @work.id,
          note: Cicero.words(100)
        }
      }
      expect(response).to have_http_status(:redirect)
      expect(LinerNote.count).to eq(initial_note_count + 1)
    end
  end

  describe "editing existing liner notes" do
    it "allows user to retrieve an existing liner note" do
      ln = create(:liner_note, work_id: @work.id)
      log_in_through_controller
      get edit_liner_note_path(@work.id)
      expect(response).to have_http_status(:success)
      expect(response.body).to match(/#{ln.note}/)
    end

    it "allows user to add text to an existing liner note" do
      ln = create(:liner_note, work_id: @work.id)
      log_in_through_controller
      patch liner_note_path(ln), params: {
        liner_note: {
          note: ln.note + " And then I added this.",
          work_id: ln.work_id
        }
      }
      expect(response).to have_http_status(:redirect)
      ln.reload
      expect(ln.note).to match(/And then I added this/)
    end
  end
end
