require 'rails_helper'

RSpec.describe "works/show.html.erb", type: :view do
  it "shows the title" do
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
    render
    expect(rendered).to match(/\(flute and piano\)/)
  end
end
