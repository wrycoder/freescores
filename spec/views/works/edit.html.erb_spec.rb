require 'rails_helper'

RSpec.describe "works/edit.html.erb", type: :view do
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
    render
    page = Nokogiri::HTML(rendered)
    hidden_tag = page.xpath('//form/input').first
    expect(hidden_tag.attribute_nodes[0].value).to match(/hidden/)
    expect(hidden_tag.attribute_nodes[1].value).to match(/_method/)
    expect(hidden_tag.attribute_nodes[2].value).to match(/patch/)
    ascii_checkbox = page.xpath("//input[@type='checkbox']").first
    expect(ascii_checkbox.nil?).to be false
    work.destroy
  end
end
