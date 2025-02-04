require 'rails_helper'

RSpec.describe "works/create.html.erb", type: :view do
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
  end

  it "shows an error" do
    work = build(:work, genre_id: @genre.id)
    work.valid?
    assign(:work, work)
    render
    expect(rendered).to match(/Parts can&#39;t be blank/)
  end

  it "shows a working form" do
    work = build(:work, genre_id: @genre.id)
    work.add_instruments({ @piano => 1, @flute => 1 })
    work.valid?
    assign(:work, work)
    render
    page = Nokogiri::HTML(rendered)
    form_tag = page.xpath('//form').first
    expect(form_tag.attribute_nodes[2].value).to match(/post/)
    expect(rendered).to_not match(/Parts can&#39;t be blank/)
  end
end
