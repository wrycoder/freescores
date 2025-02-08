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

    if !ENV['MEDIA_HOST'].nil?
      @original_media_host = ENV['MEDIA_HOST']
    else
      ENV['MEDIA_HOST'] = 'http://ourserver.com'
      @original_media_host = nil
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
    Instrument.destroy_all
    Genre.destroy_all
    ENV['MEDIA_HOST'] = @original_media_host
    ENV['FILE_ROOT'] = @original_file_root
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
    work.score_link = work.title.gsub(' ', '_') + ".pdf"
    work.recording_link = work.title.gsub(' ', '_') + ".mp3"
    work.save!
    assign(:work, work)
    render
    expect(rendered).to match(/recordings\/mp3\/#{work.title.gsub(' ', '_')}\.pdf/)
    expect(rendered).to match(/recordings\/mp3\/#{work.title.gsub(' ', '_')}\.mp3/)
    expect(rendered).to match(/ASCAP-small/)
    work.destroy
  end
end
