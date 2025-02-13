require 'rails_helper'

RSpec.describe "scores/edit.html.erb", type: :view do
  it "shows selected fields" do
    genre = create(:genre)
    piano = create(:instrument,
                  name: "piano",
                  rank: 550,
                  family: "keyboard")
    flute = create(:instrument,
                  name: "flute",
                  rank: 500,
                  family: "woodwind")
    work = build(:work, genre_id: genre.id)
    work.add_instruments({ piano => 1, flute => 1 })
    work.save!
    assign(:work, work)
    score = work.scores.new
    assign(:score, score)
    render
    expect(rendered).to match(/Add a score for #{work.title}/)
    page = Nokogiri::HTML(rendered)
    input_form = page.xpath("//form[@class='add-associated-file']")
    expect(input_form.empty?).to be false
    expect(input_form[0]["method"]).to match(/^post$/)
    expect(input_form[0]["action"]).to match(/#{scores_path}/)
    work.destroy
  end
end
