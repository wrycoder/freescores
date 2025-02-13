require 'rails_helper'

RSpec.describe "works/show.html.erb", type: :view do
  before :each do
    @genre = create(:genre)
    @piano = create(:instrument,
                  name: "piano",
                  rank: 550,
                  family: "keyboard")
    @flute = create(:instrument,
                  name: "flute",
                  rank: 500,
                  family: "woodwind")
    define_environment
  end

  after :each do
    Work.destroy_all
    Instrument.destroy_all
    Genre.destroy_all
    clear_environment
  end

  it "shows the instruments and revision" do
    work_1 = build(:work, genre_id: @genre.id)
    work_1.add_instruments({ @piano => 1, @flute => 1 })
    work_1.save!
    assign(:work, work_1)
    render
    expect(rendered).to match(/flute and piano/)
    expect(rendered).to_not match(/Revised/)
    work_2 = build(:work,
      genre_id: @genre.id,
      composed_in: 1996,
      revised_in: 2018)
    work_2.add_instruments({ @flute => 1 })
    work_2.save!
    assign(:work, work_2)
    render
    expect(rendered).to match(/flute/)
    expect(rendered).to match(/Revised/)
    work_1.destroy
    work_2.destroy
  end

  it "shows links to score and mp3, as well as ascap logo" do
    work = build(:work, genre_id: @genre.id, ascap: true)
    work.add_instruments({ @piano => 1 })
    work.save!
    work.scores.create!(
      file_name: work.title.gsub(' ', '_') + ".pdf",
      label: "Score for #{work.title}")
    work.recordings.create!(
      file_name: work.title.gsub(' ', '_') + ".mp3",
      label: "Recording of #{work.title}")
    scores = []
    recordings = []
    work.formatted_score_links { |s| scores << s }
    work.formatted_recording_links { |r| recordings << r }
    assign(:work, work)
    assign(:scores, scores)
    assign(:recordings, recordings)
    render
    expect(rendered).to match(/recordings\/mp3\/#{work.title.gsub(' ', '_')}\.pdf/)
    expect(rendered).to match(/recordings\/mp3\/#{work.title.gsub(' ', '_')}\.mp3/)
    expect(rendered).to match(/ASCAP-small/)
    work.destroy
  end
end
