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
    work_1 = build(:work, genre_id: genre.id)
    work_1.add_instruments({ piano => 1, flute => 1 })
    work_1.save!
    assign(:work, work_1)
    render
    expect(rendered).to match(/\(flute and piano\)/)
    expect(rendered).to_not match(/Revised in/)
    work_2 = build(:work,
      genre_id: genre.id,
      composed_in: 1996,
      revised_in: 2018)
    work_2.add_instruments({ flute => 1 })
    work_2.save!
    assign(:work, work_2)
    render
    expect(rendered).to match(/\(flute\)/)
    expect(rendered).to match(/Revised in/)
    work_1.destroy
    work_2.destroy
  end
end
