require 'rails_helper'

RSpec.describe "works/new.html.erb", type: :view do
  it "shows a valid form" do
    genre = create(:genre)
    piano = create(:instrument,
                  name: "piano",
                  rank: 550,
                  family: "keyboard")
    flute = create(:instrument,
                  name: "flute",
                  rank: 500,
                  family: "woodwind")
    render
    expect(rendered).to match(/Title/)
    page = Nokogiri::HTML(rendered)
    expect(page.css('.genre-selector')).to_not be nil
    genre_selector = page.css('.genre-selector')
    expect(genre_selector[0].children[2].children[0])
          .to match(/#{genre.name}/)
    part_selector = page.css('.part-selector')
    expect(part_selector[0].children[2].children[0])
          .to match(/piano/)
  end
end
